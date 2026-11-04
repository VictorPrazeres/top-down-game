class_name LevelRoom extends Node2D

@onready var player_spawn_pos: Marker2D = $PlayerSpawnPos
@onready var room_walls: Dictionary[Vector2i, TileMapLayer] = {
	Vector2i.UP: %WallUP,
	Vector2i.RIGHT: %WallRight,
	Vector2i.DOWN: %WallDown,
	Vector2i.LEFT: %WallLeft
}


func _ready() -> void:
	close_all_walls()


func open_wall(direction: Vector2i) -> void:
	if room_walls.has(direction):
		room_walls[direction].enabled = false


func close_all_walls() -> void:
	for key in room_walls:
		room_walls[key].enabled = true
