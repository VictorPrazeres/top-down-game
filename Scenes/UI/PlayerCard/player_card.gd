class_name PlayerCard extends TextureButton

var data: PlayerData

@onready var icon: TextureRect = $Icon


func set_data(value: PlayerData) -> void:
	data = value
	icon.texture = data.icon
