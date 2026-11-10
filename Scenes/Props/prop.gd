class_name Prop extends Area2D

@onready var texture: Sprite2D = $Texture


func _on_body_entered(_body: Node2D) -> void:
	DampedOscillator.animate(texture, "scale", 250, 10, 17, 0.5 * randi_range(0, 1))
