extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_option_button_item_selected(index):
	match index:
		0:
			get_window().size = Vector2(640, 360)	
		1:
			get_window().size = Vector2(1920, 1080)


func _on_back_button_up():
	get_tree().change_scene_to_file("res://scenes/menu/menu.tscn")
