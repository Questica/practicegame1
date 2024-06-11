extends Camera2D

@onready var mouse_pos
var camera_size = Vector2(640, 360)
@export var speed = 420.0
@export var edge_pan_margin = 50


# Adjust limits by half the screen size
@onready var adjusted_limit_left = limit_left + (camera_size.x / 2)
@onready var adjusted_limit_right = 1280 - (camera_size.x / 2) #limit_right #- (camera_size.x * 2)
@onready var adjusted_limit_top = limit_top + (camera_size.y / 2)
@onready var adjusted_limit_bottom = 1280 - (camera_size.y / 2) #limit_bottom #- (camera_size.y * 2)

func _process(delta):
	key_pan(delta)
	mouse_pan(delta)

func key_pan(delta):
	var pan_amount = Vector2.ZERO
	if Input.is_action_pressed("arrow_right"):
		pan_amount.x += 1
	if Input.is_action_pressed("arrow_left"):
		pan_amount.x -= 1
	if Input.is_action_pressed("arrow_down"):
		pan_amount.y += 1
	if Input.is_action_pressed("arrow_up"):
		pan_amount.y -= 1
	
	pan_amount = pan_amount.normalized()
	var new_position = position + pan_amount * delta * speed

	# Clamp the new position to the adjusted camera limits
	new_position.x = clamp(new_position.x, adjusted_limit_left, adjusted_limit_right)
	new_position.y = clamp(new_position.y, adjusted_limit_top, adjusted_limit_bottom)
	
	position = new_position

func mouse_pan(delta):
	mouse_pos = get_viewport().get_mouse_position()
	var pan_amount = Vector2.ZERO

	if mouse_pos.x >= camera_size.x - edge_pan_margin:
		pan_amount.x += 1
	elif mouse_pos.x <= edge_pan_margin:
		pan_amount.x -= 1
	
	if mouse_pos.y >= camera_size.y - edge_pan_margin + 50:
		pan_amount.y += 1
	elif mouse_pos.y <= edge_pan_margin:
		pan_amount.y -= 1

	pan_amount = pan_amount.normalized()
	var new_position = position + pan_amount * delta * speed

	# Clamp the new position to the adjusted camera limits
	new_position.x = clamp(new_position.x, adjusted_limit_left, adjusted_limit_right)
	new_position.y = clamp(new_position.y, adjusted_limit_top, adjusted_limit_bottom)
	
	position = new_position
