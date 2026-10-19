extends CanvasLayer

@onready var texture: Sprite2D = $Texture


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _process(_delta: float) -> void:
	texture.position = get_viewport().get_mouse_position()
