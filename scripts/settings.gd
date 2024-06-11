extends Node

var screenSize = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_option_button_item_selected(index):
	screenSize = index


func _on_back_button_up():
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")


func _on_save_button_up():
	print(screenSize)
	if screenSize == null:
		return
	
	var window = get_window()
	var window_size_before = window.get_size()
	match screenSize:
		0:
			window.size = Vector2(640, 360)
		1:
			window.size = Vector2(1280, 720)
		2:
			window.size = Vector2(1920, 1080)
	window.position += (window_size_before - window.size) / 2
