class_name MainMenu extends Control

@export var menu_cursor: Texture2D

@onready var main_buttons: Control = $MainButtons
@onready var settings_buttons: Control = $SettingsButtons
@onready var ui_sound: AudioStreamPlayer = $UISound
@onready var hover_sound: AudioStreamPlayer = $HoverSound
@onready var music_label: Label = %MusicLabel
@onready var sfx_label: Label = %SFXLabel
@onready var window_label: Label = %WindowLabel


func _ready() -> void:
	Cursor.texture.texture = menu_cursor
	update_audio_bus("Music", music_label, Global.settings.music)
	update_audio_bus("SFX", sfx_label, Global.settings.sfx)
	update_fullscreen(Global.settings.fullscreen)


func update_audio_bus(bus_name: String, label: Label, is_on: bool) -> void:
	AudioServer.set_bus_mute(AudioServer.get_bus_index(bus_name), not is_on)
	label.text = "%s: %s" % [bus_name, "ON" if is_on else "OFF"]


func update_fullscreen(is_on: bool) -> void:
	var mode = DisplayServer.WINDOW_MODE_FULLSCREEN if is_on else DisplayServer.WINDOW_MODE_WINDOWED
	DisplayServer.window_set_mode(mode)
	window_label.text = "FULLSCREEN" if is_on else "WINDOWED"


func _on_play_button_pressed() -> void:
	ui_sound.play()
	Transition.transition_to("res://Scenes/UI/CharacterSelection/character_selection.tscn")


func _on_settings_button_pressed() -> void:
	ui_sound.play()
	var tween := create_tween()
	tween.tween_property(main_buttons, "global_position:y", 350, 0.2)
	tween.tween_interval(0.1)
	tween.tween_property(settings_buttons, "global_position:x", 145, 0.3)


func _on_quit_button_pressed() -> void:
	ui_sound.play()
	Global.save_data()
	get_tree().quit()


func _on_music_button_pressed() -> void:
	ui_sound.play()
	Global.settings.music = not Global.settings.music
	update_audio_bus("Music", music_label, Global.settings.music)


func _on_sfx_button_pressed() -> void:
	ui_sound.play()
	Global.settings.sfx = not Global.settings.sfx
	update_audio_bus("SFX", sfx_label, Global.settings.sfx)


func _on_window_button_pressed() -> void:
	ui_sound.play()
	Global.settings.fullscreen = not Global.settings.fullscreen
	update_fullscreen(Global.settings.fullscreen)


func _on_back_button_pressed() -> void:
	ui_sound.play()
	var tween := create_tween()
	tween.tween_property(settings_buttons, "global_position:x", 558, 0.3)
	tween.tween_interval(0.1)
	tween.tween_property(main_buttons, "global_position:y", 115, 0.2)


func _on_button_mouse_entered() -> void:
	hover_sound.play()


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		Global.save_data()
