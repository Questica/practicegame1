extends State
class_name playerIdle

signal DrawOnMap

@export var player : CharacterBody2D
@export var playerSprite : Sprite2D

func enter(args: Dictionary = {}):
	print("Entering player idle")

func process(delta: float):
	#print("Updating")
	pass

func physics_process(delta: float):
	if player:
		#print("physics update")
		pass

func exit():
	pass

func mouse_down(tile_position, tile):
	if distance_from_tile(tile_position) == 1 and tile != 0:
		Transitioned.emit(self, "playerMove", {"tile_position": tile_position, "tile": tile})
		return { "box": { "rect": Rect2(tile_position, Vector2(32, 32)), "color": Color.BLUE } }
	return null

func distance_from_tile(tile_position : Vector2i):
	var self_position = Vector2i(floor(player.get_position())/ 32)
	var distance = self_position - tile_position
	return int(floor(distance.length()))

func hover(tile_position, tile):
	if distance_from_tile(tile_position) == 1 and tile != 0:
		return { "box": { "rect": Rect2(tile_position, Vector2(32, 32)), "color": Color.GREEN } }
	else:
		return { "box": { "rect": Rect2(tile_position, Vector2(32, 32)), "color": Color.RED } }
