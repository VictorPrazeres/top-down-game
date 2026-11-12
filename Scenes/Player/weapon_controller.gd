class_name WeaponController extends Node2D

var current_weapon: Weapon
var target_position: Vector2


func equip_weapon(data: WeaponData) -> void:
	var weapon_scene = Global.all_weapons[data.weapon_name]
	var weapon: Weapon = weapon_scene.instantiate()
	weapon.global_position.y = -8
	current_weapon = weapon
	current_weapon.data = Global.selected_weapon
	add_child(weapon)


func rotate_weapon() -> void:
	if not current_weapon:
		return
	
	current_weapon.pivot.look_at(target_position)
