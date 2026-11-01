class_name DamageText extends Control

@onready var label: Label = $Label


func setup(value: float) -> void:
	label.text = str(value)
	await get_tree().create_timer(0.5).timeout
	queue_free()
