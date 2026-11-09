class_name MapController extends Control

const MAP_CELL_SCENE = preload("uid://b081fl6ails64")

var minimap_cells: Dictionary[Vector2i, MapCell] = {}
var player_coord := Vector2i.MAX
var cell_size: Vector2


func update_on_room_entered(new_room_coord: Vector2i) -> void:
	if new_room_coord == player_coord:
		return
	
	if minimap_cells.has(player_coord):
		minimap_cells[player_coord].set_player_active(false)
	
	var new_cell: MapCell
	if minimap_cells.has(new_room_coord):
		new_cell = minimap_cells[new_room_coord]
	else:
		new_cell = create_map_cell(new_room_coord)
	
	player_coord = new_room_coord
	new_cell.set_player_active(true)


func create_map_cell(coord: Vector2i) -> MapCell:
	var new_cell: MapCell = MAP_CELL_SCENE.instantiate()
	
	minimap_cells[coord] = new_cell
	add_child(new_cell)
	
	if cell_size == Vector2.ZERO:
		cell_size = new_cell.size
	
	var relative_pos = Vector2(coord.x * cell_size.x, coord.y * cell_size.y)
	new_cell.position = (size / 2.0) + relative_pos - (cell_size / 2.0)
	return new_cell


func reset() -> void:
	for cell: MapCell in minimap_cells.values():
		cell.queue_free()
	
	minimap_cells.clear()
	player_coord = Vector2i.MAX
	cell_size = Vector2.ZERO
