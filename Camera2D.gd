extends Camera2D

@onready var camera = self
@onready var mouse_pos
@onready var screen_size = get_viewport().size
@onready var background = %Background
@onready var backgroundsize = background.region_rect.size

@export var speed = 420.0
@export var edge_pan_margin = 50

func _ready():
	camera.limit_bottom = backgroundsize.y
	camera.limit_right = backgroundsize.x

func _process(delta):
	key_pan(delta)
	mouse_pan(delta)
	print(backgroundsize)

func key_pan(delta):
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
	position += pan_amount * delta * speed

func mouse_pan(delta):
	mouse_pos = get_viewport().get_mouse_position()
	var pan_amount = Vector2.ZERO

	if mouse_pos.x >= screen_size.x - edge_pan_margin:
		pan_amount.x += 1
	elif mouse_pos.x <= edge_pan_margin:
		pan_amount.x -= 1
	
	if mouse_pos.y >= screen_size.y - edge_pan_margin:
		pan_amount.y += 1
	elif mouse_pos.y <= edge_pan_margin:
		pan_amount.y -= 1

	pan_amount = pan_amount.normalized()
	position += pan_amount * delta * speed
