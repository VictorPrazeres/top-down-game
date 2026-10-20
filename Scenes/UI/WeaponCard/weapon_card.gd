class_name WeaponCard extends TextureButton

var data: WeaponData

@onready var icon: TextureRect = $Icon


func set_data(value: WeaponData) -> void:
	data = value
	icon.texture = data.icon
