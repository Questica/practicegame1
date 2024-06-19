extends CharacterBody2D

@export var map_generator: Node

@onready var world_tile_map = map_generator.get_node("WorldTileMap")
var move_counter_start = 4
var move_counter = move_counter_start

func _ready():
	self.set_position((map_generator.dirt[0] * 32) + Vector2i(16, 16))
	PlayerSingleton.player = self
	Engine.time_scale = 0.5

func _input(event):
	if Input.is_action_just_released("mouse_leftclick"):
		var mouse_pos = get_global_mouse_position()
		var tile = Vector2i(floor(mouse_pos / 32))
		move(tile)

func move(tile : Vector2i):
	var tile_data : TileData = world_tile_map.get_cell_tile_data(0, tile)
	if (tile_data.get_terrain() == 2):
		return
	if (move_counter <= 0):
		return
	var tile_distance = distance_from_tile(tile)
	if tile_distance > 0 and move_counter - tile_distance >= 0:
		self.set_position((tile * 32) + Vector2i(16, 16))
		move_counter += - tile_distance

func distance_from_tile(tile : Vector2i):
	var self_position = Vector2i(floor(self.get_position())/ 32)
	var distance = self_position - tile
	return int(floor(distance.length()))

func set_move_counter(number: int):
	move_counter = number
	
func reset_move_counter():
	move_counter = move_counter_start

func next_turn():
	if move_counter <= 0:
		await slow_time()
		reset_move_counter()
		return true
	return false
	

func slow_time():
	var tween = get_tree().create_tween()
	
	#tween.set_speed_scale(1.0 / Engine.time_scale)
	
	# Speed up the time scale to 1.0 over 1 second
	tween.tween_property(Engine, "time_scale", 1.0, 1.0).set_trans(Tween.TRANS_SINE)
	
	# Wait for 1 second
	tween.tween_interval(1.0)
	 
	# Slow down the time scale back to 0.5 over 1 second
	tween.tween_property(Engine, "time_scale", 0.5, 1.0).set_trans(Tween.TRANS_SINE)
