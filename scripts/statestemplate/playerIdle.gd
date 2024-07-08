extends State
class_name playerIdle

@export var player : CharacterBody2D
@export var playerSprite : Sprite2D

func enter(args=null):
	print("Entering player idle")

func process(delta: float):
	print("Updating")

func physics_process(delta: float):
	if player:
		print("physics update")

func exit():
	pass

func mouse_down(tile):
	if distance_from_tile(tile) == 1:
		Transitioned.emit(self, "playerMove", tile)
		return {"tilebox": Color.BLUE}
	return null

func distance_from_tile(tile : Vector2i):
	var self_position = Vector2i(floor(player.get_position())/ 32)
	var distance = self_position - tile
	return int(floor(distance.length()))

func hover(tile):
	if distance_from_tile(tile) == 1:
		return {"tilebox": Color.GREEN}
	else:
		return {"tilebox": Color.RED}
