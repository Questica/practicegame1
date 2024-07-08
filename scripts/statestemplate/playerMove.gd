extends State
class_name playerMove

@export var player : CharacterBody2D
@export var playerSprite : Sprite2D

var move_tween : Tween

func Enter(args=null):
	if args == null:
		return
	move(args)

func Update(delta: float):
	pass

func Physics_Update(delta: float):
	if player:
		print("physics update")

func move(tile : Vector2i):
	#if player.move_counter > 0:
	var tile_distance = distance_from_tile(tile)
	if tile_distance == 1:
		var pos = Vector2(tile) * 32 + Vector2(16, 16)
		move_tween = create_tween()
		move_tween.tween_property(player, "position", pos, 0.5)
		move_tween.tween_callback(_on_tween_completed)

func distance_from_tile(tile : Vector2i):
	var self_position = Vector2i(floor(player.get_position())/ 32)
	var distance = self_position - tile
	return int(floor(distance.length()))

func _on_tween_completed():
	Transitioned.emit(self, "playerIdle")

func mouse_down(tile):
	pass

func Exit():
	pass
