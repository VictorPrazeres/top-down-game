class_name CharacterSelection extends Control

const PLAYER_CARD_SCENE = preload("uid://8ioepndp2hoa")
const WEAPON_CARD_SCENE = preload("uid://c54j4u6atitcq")

@export var selection_cursor: Texture2D
@export var players: Array[PlayerData]
@export var weapons: Array[WeaponData]

@onready var player_container: HBoxContainer = $PlayerContainer
@onready var weapon_container: HBoxContainer = $WeaponContainer
@onready var ui_sound: AudioStreamPlayer = $UISound
@onready var hover_sound: AudioStreamPlayer = $HoverSound


func _ready() -> void:
	Cursor.texture.texture = selection_cursor
	load_selection_items()


func load_selection_items() -> void:
	for node in player_container.get_children():
		node.queue_free()
	
	for node in weapon_container.get_children():
		node.queue_free()
	
	for data: PlayerData in players:
		var card: PlayerCard = PLAYER_CARD_SCENE.instantiate()
		card.pressed.connect(_on_player_card_pressed.bind(data, card))
		player_container.add_child(card)
		card.set_data(data)
	
	for data: WeaponData in weapons:
		var card: WeaponCard = WEAPON_CARD_SCENE.instantiate()
		card.pressed.connect(_on_weapon_card_pressed.bind(data, card))
		weapon_container.add_child(card)
		card.set_data(data)


func _on_play_button_pressed() -> void:
	if not Global.selected_player and not Global.selected_weapon:
		return
	
	ui_sound.play()
	Transition.transition_to("res://Scenes/Arena/arena.tscn")


func _on_back_button_pressed() -> void:
	ui_sound.play()
	Transition.transition_to("res://Scenes/UI/main_menu.tscn")


func _on_player_card_pressed(data: PlayerData, selected_card: PlayerCard) -> void:
	ui_sound.play()
	Global.selected_player = data
	for card: PlayerCard in player_container.get_children():
		card.selector.hide()
	selected_card.selector.show()


func _on_weapon_card_pressed(data: WeaponData, selected_card: WeaponCard) -> void:
	ui_sound.play()
	Global.selected_weapon = data
	for card: WeaponCard in weapon_container.get_children():
		card.selector.hide()
	selected_card.selector.show()


func _on_play_button_mouse_entered() -> void:
	hover_sound.play()


func _on_back_button_mouse_entered() -> void:
	hover_sound.play()
