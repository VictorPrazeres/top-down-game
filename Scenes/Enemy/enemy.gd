class_name Enemy extends CharacterBody2D

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

@onready var anim_texture: AnimatedSprite2D = $AnimTexture
@onready var player_detector: Area2D = $PlayerDetector
@onready var enemy_detector: Area2D = $EnemyDetector
@onready var hurt_sound: AudioStreamPlayer = $HurtSound
@onready var health_component: HealthComponent = $HealthComponent
@onready var health_bar: ProgressBar = $HealthBar


func _ready() -> void:
	health_bar.value = 1.0
	health_component.init_health(max_health)


func _physics_process(_delta: float) -> void:
	if not Global.player_ref: return
	if not can_move: return
	
	var dir := global_position.direction_to(Global.player_ref.global_position)
	for enemy: Enemy in enemy_detector.get_overlapping_bodies():
		if enemy != self and enemy.is_inside_tree():
			var vector = global_position - enemy.global_position
			dir += 10 * vector.normalized() / vector.length()
	
	velocity = dir * chase_speed
	move_and_slide()
	rotate_enemy()


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


func _on_player_detector_body_entered(_body: Node2D) -> void:
	enemy_dead()


func _on_health_component_on_unit_damaged(_amount: float) -> void:
	health_bar.value = health_component.current_health / max_health
	anim_texture.material = Global.HIT_MATERIAL
	await get_tree().create_timer(0.15).timeout
	anim_texture.material = null


func _on_health_component_on_unit_dead() -> void:
	enemy_dead()
