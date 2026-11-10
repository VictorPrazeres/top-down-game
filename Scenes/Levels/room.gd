class_name LevelRoom extends Node2D

var tiles: Array[Vector2i]
var is_cleared: bool

@onready var player_spawn_pos: Marker2D = $PlayerSpawnPos
@onready var tile_data: TileMapLayer = $TileData
@onready var room_walls: Dictionary[Vector2i, TileMapLayer] = {
	Vector2i.UP: %WallUP,
	Vector2i.RIGHT: %WallRight,
	Vector2i.DOWN: %WallDown,
	Vector2i.LEFT: %WallLeft
}
@onready var clear_door_nodes: Dictionary[Vector2i, TileMapLayer] = {
	Vector2i.UP: %DoorUP,
	Vector2i.RIGHT: %DoorRight,
	Vector2i.DOWN: %DoorDown,
	Vector2i.LEFT: %DoorLeft
}


func _ready() -> void:
	close_all_walls()
	register_tiles()


func register_tiles() -> void:
	for tile in tile_data.get_used_cells():
		tiles.append(tile)


func create_props(data: LevelData) -> void:
	for i in data.max_props_per_room:
		var tile_coord: Vector2i = tiles.pick_random()
		var tile_pos: Vector2 = tile_data.map_to_local(tile_coord)
		var random_prop = data.props.pick_random()
		var instance: Area2D = random_prop.instantiate()
		instance.position = tile_pos
		add_child(instance)


func lock_room() -> void:
	for direction in clear_door_nodes:
		var wall_door = room_walls[direction]
		var clear_door = clear_door_nodes[direction]
		
		if wall_door and not wall_door.enabled:
			clear_door.enabled = true


func unlock_room() -> void:
	for direction in clear_door_nodes:
		clear_door_nodes[direction].enabled = false


func open_wall(direction: Vector2i) -> void:
	if room_walls.has(direction):
		room_walls[direction].enabled = false


func close_all_walls() -> void:
	for key in room_walls:
		room_walls[key].enabled = true


func _on_player_detector_body_entered(_body: Node2D) -> void:
	EventBus.on_player_room_entered.emit(self)
