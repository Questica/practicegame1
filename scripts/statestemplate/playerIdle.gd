extends State
class_name playerIdle

@export var player : CharacterBody2D
@export var playerSprite : Sprite2D

func Enter(args=null):
	print("Entering player idle")

func Update(delta: float):
	print("Updating")

func Physics_Update(delta: float):
	if player:
		print("physics update")

func Exit():
	pass

func mouse_down(tile):
	if distance_from_tile(tile) <= 1:
		Transitioned.emit(self, "playerMove", tile)

func distance_from_tile(tile : Vector2i):
	var self_position = Vector2i(floor(player.get_position())/ 32)
	var distance = self_position - tile
	return int(floor(distance.length()))
