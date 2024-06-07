extends Camera2D

@onready var camera = $"."

var viewportmousepos = get_global_mouse_position().x
var mousepos = get_global_mouse_position().x

func _process(delta):
	pan(delta)

func pan(delta):
	var pan_amount = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		pan_amount.x += 1
	if Input.is_action_pressed("ui_left"):
		pan_amount.x -= 1
	if Input.is_action_pressed("ui_down"):
		pan_amount.y += 1
	if Input.is_action_pressed("ui_up"):
		pan_amount.y -= 1
	
	pan_amount = pan_amount.normalized()
	position += pan_amount * delta * 420
