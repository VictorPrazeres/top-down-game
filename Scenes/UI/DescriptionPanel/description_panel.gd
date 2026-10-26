class_name DescriptionPanel extends Control

@onready var label: Label = %Label


func set_text(value: String) -> void:
	label.text = value
