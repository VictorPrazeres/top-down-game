class_name LevelData extends Resource

@export var num_sub_levels := 4
@export var num_rooms := 10
@export var room_size := Vector2i(384, 384)
@export var room_scene: PackedScene
@export var min_enemies_per_room := 5
@export var max_enemies_per_room := 10
@export var enemy_scenes: Array[PackedScene]
@export var store_data: Array[LevelStoreData]
