class_name Arena extends Node

@onready var health_bar: TextureProgressBar = %HealthBar
@onready var mana_bar: TextureProgressBar = %ManaBar


func _ready() -> void:
	EventBus.on_player_health_updated.connect(_on_player_health_updated)


func _on_player_health_updated(current_health: float, max_health: float) -> void:
	health_bar.value = current_health / max_health
