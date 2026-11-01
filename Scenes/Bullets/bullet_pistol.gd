class_name Bullet extends Area2D

var data: WeaponData


func setup(new_data: WeaponData) -> void:
	data = new_data


func _process(delta: float) -> void:
	if not data: return
	move_local_x(data.bullet_speed * delta)


func _on_body_entered(body: Node2D) -> void:
	Global.create_explosion(global_position)
	Global.create_damage_text(data.damage, body.global_position)
	queue_free()
