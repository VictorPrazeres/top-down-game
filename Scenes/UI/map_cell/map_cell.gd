class_name MapCell extends Control

@onready var player_icon: TextureRect = $PlayerIcon


func _ready() -> void:
	set_player_active(false)


func set_player_active(value: bool) -> void:
	player_icon.visible = value
