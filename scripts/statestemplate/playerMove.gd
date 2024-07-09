extends State
class_name playerMove

@export var player : CharacterBody2D
@export var playerSprite : Sprite2D

var move_tween : Tween

func enter(args: Dictionary = {}):
	if args.tile_position == null or args.tile == null:
		return 
	move(args.tile_position, args.tile)

func process(delta: float):
	pass

func physics_process(delta: float):
	if player:
		#print("physics update")
		pass

func move(tile_position : Vector2i, tile):
	var tile_distance = distance_from_tile(tile_position)
	if tile_distance == 1:
		var pos = Vector2(tile_position) * 32 + Vector2(16, 16)
		move_tween = create_tween()
		move_tween.tween_property(player, "position", pos, 0.5)
		move_tween.tween_callback(_on_tween_completed)

func distance_from_tile(tile : Vector2i):
	var self_position = Vector2i(floor(player.get_position())/ 32)
	var distance = self_position - tile
	return int(floor(distance.length()))

func _on_tween_completed():
	Transitioned.emit(self, "playerIdle")

func mouse_down(tile_position, tile):
	return null

func exit():
	pass

func hover(tile_position, tile):
	pass
