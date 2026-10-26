class_name WeaponCard extends TextureButton

var data: WeaponData

@onready var icon: TextureRect = $Icon
@onready var hover_sound: AudioStreamPlayer = $HoverSound
@onready var selector: TextureRect = $Selector
@onready var description_panel: DescriptionPanel = $DescriptionPanel


func set_data(value: WeaponData) -> void:
	data = value
	icon.texture = data.icon
	set_description()


func set_description() -> void:
	description_panel.set_text(data.description)


func _on_mouse_entered() -> void:
	hover_sound.play()
	DampedOscillator.animate(icon, "scale", randf_range(400, 450), randf_range(5, 10), randf_range(10, 15), 0.5)
	
	description_panel.show()
	DampedOscillator.animate(description_panel, "scale", randf_range(400, 450), randf_range(5, 10), randf_range(10, 15), 0.5)
	DampedOscillator.animate(description_panel, "rotation_degrees", 300, 7.5, 15, 0.5 * randf_range(-20, 20))


func _on_mouse_exited() -> void:
	description_panel.hide()
