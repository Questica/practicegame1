extends CharacterBody2D

@export var map_generator: Node

@onready var world_tile_map = map_generator.get_node("WorldTileMap")

var dirt = []
var floor = []
var cliff = []

func _ready():
	iterate_world()
	self.set_position((dirt[0] * 32) + Vector2(16, 16))
	print(dirt[0] * 32)
	PlayerSingleton.player = self

func _input(event):
	if Input.is_action_just_released("mouse_leftclick"):
		var mouse_pos = get_global_mouse_position()
		mouse_pos = Vector2i(floor(mouse_pos / 32))
		print(mouse_pos)
		var tile_data : TileData = world_tile_map.get_cell_tile_data(0, mouse_pos)
		print(tile_data.get_terrain())


func iterate_world():  #This should probably not be in here.
	for x in range(0, world_tile_map.get_used_rect().size.x):
		for y in range(0, world_tile_map.get_used_rect().size.y):
			var tile_data = world_tile_map.get_cell_tile_data(0, Vector2(x, y))
			match tile_data.get_terrain():
				0:
					floor.append(Vector2(x, y))
				1:
					dirt.append(Vector2(x, y))
				2:
					cliff.append(Vector2(x, y))
