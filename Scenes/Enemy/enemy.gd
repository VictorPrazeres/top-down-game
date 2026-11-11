class_name Enemy extends CharacterBody2D

var can_move: bool = true

@onready var anim_texture: AnimatedSprite2D = $AnimTexture
@onready var player_detector: Area2D = $PlayerDetector
@onready var hurt_sound: AudioStreamPlayer = $HurtSound


func _physics_process(_delta: float) -> void:
	if not Global.player_ref: return
	if not can_move: return
	
	var dir := global_position.direction_to(Global.player_ref.global_position)
	velocity = dir * 50.0
	move_and_slide()
	rotate_enemy()


func rotate_enemy() -> void:
	if global_position.x > Global.player_ref.global_position.x:
		anim_texture.flip_h = true
	elif global_position.x < Global.player_ref.global_position.x:
		anim_texture.flip_h = false


func _on_player_detector_body_entered(_body: Node2D) -> void:
	anim_texture.play("die")
	await anim_texture.animation_finished
	EventBus.on_enemy_die.emit()
	queue_free()
