extends CharacterBody2D

@export var map_generator: Node

@onready var world_tile_map = map_generator.get_node("WorldTileMap")

var moveCounter = 2

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
	if (tile_data.get_terrain() == 0 or tile_data.get_terrain() == 1) and tile_in_range(tile, moveCounter):
		self.set_position((tile * 32) + Vector2i(16, 16))

func tile_in_range(tile : Vector2i, range):
	var self_position = Vector2i(floor(self.get_position())/ 32)
	var distance = self_position - tile
	if distance.length() <= range + .5:  #.5 allows for corners...
		return true
	return false
