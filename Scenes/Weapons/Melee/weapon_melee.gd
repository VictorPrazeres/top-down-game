class_name WeaponMelee extends Weapon

var can_use: bool = true
var entities: Array[Node2D]

@onready var texture: Sprite2D = %Texture
@onready var slash: GPUParticles2D = %SlashParticle
@onready var animator: AnimationPlayer = $Animator
@onready var slash_sound: AudioStreamPlayer = $SlashSound
@onready var cooldown: Timer = $Cooldown


func _ready() -> void:
	cooldown.wait_time = data.cooldown


func use_weapon() -> void:
	if not can_use:
		return
	
	can_use = false
	cooldown.start()
	slash_sound.play()
	animator.play("slash")
	print(entities)
	
	slash.global_rotation = pivot.global_rotation
	slash.emitting = true


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		use_weapon()


func _on_cooldown_timeout() -> void:
	can_use = true
	animator.play("idle")


func _on_hitbox_body_entered(body: Node2D) -> void:
	if is_instance_valid(body):
		entities.append(body)


func _on_hitbox_body_exited(body: Node2D) -> void:
	if is_instance_valid(body):
		entities.erase(body)
