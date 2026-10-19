class_name WeaponRanged extends Weapon

var direction: Vector2

@onready var texture: Sprite2D = %Texture


func _process(_delta: float) -> void:
	rotate_weapon()


func use_weapon() -> void:
	pass


func rotate_weapon() -> void:
	direction = get_global_mouse_position() - global_position
	texture.flip_v = direction.x < 0
