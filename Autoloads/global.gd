extends Node

var save_path = "user://save.json"
var settings: Dictionary = {
	"music": true,
	"sfx": true,
	"fullscreen": true
}
var all_playes: Dictionary[String, PackedScene] = {
	"Bunny": preload("uid://brqlu552oijhw"),
	"Dog": preload("uid://c5oxdpdqidm62"),
	"Mouse": preload("uid://dmur05tmvsy37"),
	"Beaver": preload("uid://denj0kqwpgd5i")
}
var selected_player: PlayerData
var selected_weapon: WeaponData


func get_player() -> PackedScene:
	return all_playes[selected_player.id]


func save_data() -> void:
	var save = settings.duplicate()
	
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	var json_string = JSON.stringify(save)
	file.store_string(json_string)
	file.close()


func load_data() -> void:
	if not FileAccess.file_exists(save_path):
		return
	
	var file = FileAccess.open(save_path, FileAccess.READ)
	var json = file.get_as_text()
	var data = JSON.parse_string(json)
	file.close()
	
	settings = data
