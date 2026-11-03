class_name Arena extends Node

@export var arena_cursor: Texture2D
@export var level_data: LevelData

var grid: Dictionary[Vector2i, LevelRoom] = {}
var start_room_coord: Vector2i
var end_room_coord: Vector2i

@onready var health_bar: TextureProgressBar = %HealthBar
@onready var mana_bar: TextureProgressBar = %ManaBar


func _ready() -> void:
	Cursor.texture.texture = arena_cursor
	EventBus.on_player_health_updated.connect(_on_player_health_updated)
	
	generate_level_layout()
	select_special_rooms()
	load_game_selection()


func generate_level_layout() -> void:
	grid.clear()
	
	print("Creating layout...")
	var current_coord := Vector2i.ZERO
	grid[current_coord] = null
	var directions := [Vector2i.UP, Vector2i.DOWN, Vector2i.RIGHT, Vector2i.LEFT]
	
	while grid.size() < level_data.num_rooms:
		if randf() > 0.5:
			current_coord = grid.keys().pick_random()
		
		var random_direction = directions.pick_random()
		var next_coord = current_coord + random_direction
		
		var attempts = 0
		while grid.has(next_coord) and attempts < 10:
			random_direction = directions.pick_random()
			next_coord = current_coord + random_direction
			attempts += 1
		
		if not grid.has(next_coord):
			grid[next_coord] = null
	
	for key: Vector2i in grid.keys():
		print(key)


func select_special_rooms() -> void:
	pass


func load_game_selection() -> void:
	var player: Player = Global.get_player().instantiate()
	add_child(player)
	player.weapon_controller.equip_weapon()


func _on_player_health_updated(current_health: float, max_health: float) -> void:
	health_bar.value = current_health / max_health
