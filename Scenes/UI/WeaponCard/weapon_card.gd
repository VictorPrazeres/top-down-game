class_name WeaponCard extends TextureButton

var data: WeaponData

@onready var icon: TextureRect = $Icon
@onready var hover_sound: AudioStreamPlayer = $HoverSound


func set_data(value: WeaponData) -> void:
	data = value
	icon.texture = data.icon


func _on_mouse_entered() -> void:
	hover_sound.play()
	DampedOscillator.animate(icon, "scale", randf_range(400, 450), randf_range(5, 10), randf_range(10, 15), 0.5)
