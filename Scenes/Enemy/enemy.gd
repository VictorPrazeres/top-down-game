class_name Enemy extends CharacterBody2D

enum EnemyStates {
	FINDING_DESTINATION,
	MOVING,
	ATTACKING
}

@export_enum("Chase", "Weapon") var enemy_type = "Chase"
@export var max_health := 5.0
@export var collision_damage := 2.0
@export var death_texture: Texture2D
@export_group("Enemy Chase")
@export var chase_speed := 60.0
@export_group("Enemy Weapon")
@export var move_speed := 40.0
@export var weapon: WeaponData

var can_move: bool = true
var is_killed: bool = false
var cooldown: float
var parent_room: LevelRoom
var enemy_state: EnemyStates
var move_destination: Vector2

@onready var anim_texture: AnimatedSprite2D = $AnimTexture
@onready var player_detector: Area2D = $PlayerDetector
@onready var enemy_detector: Area2D = $EnemyDetector
@onready var hurt_sound: AudioStreamPlayer = $HurtSound
@onready var health_component: HealthComponent = $HealthComponent
@onready var health_bar: ProgressBar = $HealthBar
@onready var weapon_controller: WeaponController = $WeaponController


func _ready() -> void:
	health_bar.value = 1.0
	health_component.init_health(max_health)
	
	if not weapon: return
	weapon_controller.equip_weapon(weapon)


func _process(delta: float) -> void:
	if not Global.player_ref: return
	rotate_enemy()
	
	if enemy_state == EnemyStates.ATTACKING:
		manage_weapon(delta)


func _physics_process(_delta: float) -> void:
	if not Global.player_ref: return
	if not can_move: return
	
	match enemy_type:
		"Chase":
			run_enemy_chase()
		"Weapon":
			run_enemy_weapon()


func run_enemy_chase() -> void:
	var dir := global_position.direction_to(Global.player_ref.global_position)
	for enemy: Enemy in enemy_detector.get_overlapping_bodies():
		if enemy != self and enemy.is_inside_tree():
			var vector = global_position - enemy.global_position
			dir += 10 * vector.normalized() / vector.length()
	
	velocity = dir * chase_speed
	move_and_slide()


func run_enemy_weapon() -> void:
	match enemy_state:
		EnemyStates.FINDING_DESTINATION:
			var local_pos = parent_room.get_free_spawn_position()
			move_destination = parent_room.to_global(local_pos)
			enemy_state = EnemyStates.MOVING
		
		EnemyStates.MOVING:
			var dir = global_position.direction_to(move_destination)
			velocity = dir * move_speed
			move_and_slide()
			if global_position.distance_to(move_destination) < 2.0:
				velocity = Vector2.ZERO
				enemy_state = EnemyStates.ATTACKING
		
		EnemyStates.ATTACKING:
			velocity = Vector2.ZERO
			move_and_slide()
			await get_tree().create_timer(1.0).timeout
			enemy_state = EnemyStates.FINDING_DESTINATION


func manage_weapon(delta: float) -> void:
	if not weapon: return
	if not weapon_controller: return
	weapon_controller.target_position = Global.player_ref.global_position
	weapon_controller.rotate_weapon()
	
	cooldown -= delta
	if cooldown <= 0:
		weapon_controller.current_weapon.use_weapon()
		cooldown = weapon_controller.current_weapon.data.cooldown


func rotate_enemy() -> void:
	if global_position.x > Global.player_ref.global_position.x:
		anim_texture.flip_h = true
	elif global_position.x < Global.player_ref.global_position.x:
		anim_texture.flip_h = false


func enemy_dead() -> void:
	if is_killed:
		return
	
	is_killed = true
	Global.create_death_particle(death_texture, global_position)
	EventBus.on_enemy_die.emit()
	queue_free()


func _on_player_detector_body_entered(body: Node2D) -> void:
	body.health_component .take_damage(collision_damage)
	enemy_dead()


func _on_health_component_on_unit_damaged(_amount: float) -> void:
	health_bar.value = health_component.current_health / max_health
	anim_texture.material = Global.HIT_MATERIAL
	await get_tree().create_timer(0.15).timeout
	anim_texture.material = null


func _on_health_component_on_unit_dead() -> void:
	enemy_dead()
