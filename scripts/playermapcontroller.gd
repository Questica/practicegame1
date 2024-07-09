extends Node
class_name playerMapController

@export var player: CharacterBody2D
@export var map_generator: Node2D

func _input(event):
	var tile_position = player.get_tile_position_at_mouse()
	if not tile_position or player.move_counter <= 0: return
	
	var tile = map_generator.get_tile_at_position(tile_position)
	hover(tile_position, tile)
	
	if Input.is_action_just_released("mouse_leftclick"):
		mouse_down(tile_position, tile)

func hover(tile_position, tile):
	var result = player.hover(tile_position, tile)
	if result and result.box:
		map_generator.box = result.box
		map_generator.queue_redraw()

func mouse_down(tile_position, tile):
	var result = player.mouse_down(tile_position, tile)
	if result and result.box:
		map_generator.box = result.box
		map_generator.queue_redraw()
