class_name WeaponRanged extends Weapon

var direction: Vector2
var cooldown: float

@onready var texture: Sprite2D = %Texture
@onready var fire_position: Marker2D = %FirePosition


func _process(delta: float) -> void:
	rotate_weapon()
	
	cooldown -= delta
	if Input.is_action_pressed("shoot"):
		if cooldown <= 0:
			use_weapon()
			cooldown = data.cooldown


func use_weapon() -> void:
	var bullet: Bullet = data.bullet_scene.instantiate()
	bullet.setup(data)
	bullet.global_position = fire_position.global_position
	bullet.global_rotation = pivot.global_rotation + deg_to_rad(randf_range(-data.spread, data.spread))
	get_tree().root.add_child(bullet)


func rotate_weapon() -> void:
	direction = get_global_mouse_position() - global_position
	texture.flip_v = direction.x < 0
