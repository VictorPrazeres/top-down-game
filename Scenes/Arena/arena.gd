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
	create_rooms()
	create_corridors()
	#load_game_selection()


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
		
		# If next_coord exists, find a new one
		var attempts = 0
		while grid.has(next_coord) and attempts < 10:
			random_direction = directions.pick_random()
			next_coord = current_coord + random_direction
			attempts += 1
		
		# If next_coord is valid, add to grid
		if not grid.has(next_coord):
			grid[next_coord] = null
	
	for key: Vector2i in grid.keys():
		print(key)


func create_rooms() -> void:
	print("Creating rooms...")
	for room_coord: Vector2i in grid.keys():
		var room_instance: LevelRoom = level_data.room_scene.instantiate()
		room_instance.position = room_coord * level_data.room_size
		add_child(room_instance)
		
		# Link each coord with a room instance
		grid[room_coord] = room_instance
		
		# connect rooms using directions
		connect_rooms(room_coord, room_instance)


func create_corridors() -> void:
	print("Creating corridors...")
	for room_coord: Vector2i in grid.keys():
		var room_instance: LevelRoom = grid[room_coord]
		
		# Create right connection
		var right_neighbor = room_coord + Vector2i.RIGHT
		if grid.has(right_neighbor):
			var corridor: Node2D = level_data.h_corridor.instantiate()
			var room_pos = room_instance.position
			var neighbor_pos = grid[right_neighbor].position
			corridor.position = (room_pos + neighbor_pos) / 2.0
			add_child(corridor)
		
		# Create down connection
		var down_neighbor = room_coord + Vector2i.DOWN
		if grid.has(down_neighbor):
			var corridor: Node2D = level_data.v_corridor.instantiate()
			var room_pos = room_instance.position
			var neighbor_pos = grid[down_neighbor].position
			corridor.position = (room_pos + neighbor_pos) / 2.0
			add_child(corridor)


func connect_rooms(room_coord: Vector2i, room_instance: LevelRoom) -> void:
	var directions := [Vector2i.UP, Vector2i.DOWN, Vector2i.RIGHT, Vector2i.LEFT]
	for direction in directions:
		var neighbor_coord = room_coord + direction
		if grid.has(neighbor_coord):
			room_instance.open_wall(direction)


func select_special_rooms() -> void:
	start_room_coord = Vector2i.ZERO
	end_room_coord = find_farthest_room()
	print("Start: %s" % start_room_coord)
	print("End: %s" % end_room_coord)


func find_farthest_room() -> Vector2i:
	var farthest_room_coord := start_room_coord
	var max_dist := 0.0
	for room_cord: Vector2i in grid.keys():
		var dist = start_room_coord.distance_to(room_cord)
		if dist > max_dist:
			max_dist = dist
			farthest_room_coord = room_cord
	return farthest_room_coord


func load_game_selection() -> void:
	var player: Player = Global.get_player().instantiate()
	add_child(player)
	player.weapon_controller.equip_weapon()


func _on_player_health_updated(current_health: float, max_health: float) -> void:
	health_bar.value = current_health / max_health
