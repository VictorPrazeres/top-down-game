class_name EnemySpawner extends Node2D

@export var arena: Arena

var enemies: Array[Enemy] = []
var enemies_killed: int


func _ready() -> void:
	EventBus.on_enemy_die.connect(_on_enemy_die)


func spawn_enemies(data: LevelData, room: LevelRoom) -> void:
	if data.enemy_scenes.is_empty():
		return
	
	await get_tree().create_timer(0.5).timeout
	
	var amount = randi_range(data.min_enemies_per_room, data.max_enemies_per_room)
	for i in amount:
		var spawn_local_pos = room.get_free_spawn_position()
		var spawn_global_pos = room.to_global(spawn_local_pos)
		
		var marker = Global.SPAWN_MARKER_SCENE.instantiate()
		marker.global_position = spawn_global_pos
		get_parent().add_child(marker)
		await marker.get_child(1).animation_finished
		
		var random_scene = data.enemy_scenes.pick_random()
		var enemy: Enemy = random_scene.instantiate()
		get_parent().add_child(enemy)
		enemy.parent_room = arena.current_room
		enemy.global_position = spawn_global_pos
		enemies.append(enemy)


func _on_enemy_die() -> void:
	enemies_killed += 1
	if enemies_killed >= enemies.size():
		EventBus.on_room_cleared.emit()
		enemies.clear()
		enemies_killed = 0
