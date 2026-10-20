class_name Arena extends Node

@export var arena_cursor: Texture2D

@onready var health_bar: TextureProgressBar = %HealthBar
@onready var mana_bar: TextureProgressBar = %ManaBar


func _ready() -> void:
	Cursor.texture.texture = arena_cursor
	EventBus.on_player_health_updated.connect(_on_player_health_updated)
	load_game_selection()


func load_game_selection() -> void:
	var player = Global.get_player().instantiate()
	add_child(player)


func _on_player_health_updated(current_health: float, max_health: float) -> void:
	health_bar.value = current_health / max_health
