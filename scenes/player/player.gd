extends CharacterBody2D

@export var map_generator: Node

@onready var world_tile_map = map_generator.get_node("WorldTileMap")
var move_counter_start = 4
var move_counter = move_counter_start

signal move_counter_changed(newNumber: int)


func _ready():
	self.set_position((map_generator.dirt[0] * 32) + Vector2i(16, 16))
	PlayerSingleton.player = self

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
		subtract_move_counter(tile_distance)

func distance_from_tile(tile : Vector2i):
	var self_position = Vector2i(floor(self.get_position())/ 32)
	var distance = self_position - tile
	return int(floor(distance.length()))

func subtract_move_counter(number: int):
	set_move_counter(move_counter-number)

func set_move_counter(number: int):
	move_counter = number
	move_counter_changed.emit(move_counter)

func reset_move_counter():
	set_move_counter(move_counter_start)


func next_turn():
	if move_counter <= 0:
		reset_move_counter()
		return true
	return false
