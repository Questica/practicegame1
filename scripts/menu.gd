extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_settings_button_up():
	get_tree().change_scene_to_file("res://scenes/menu/settings.tscn")


func _on_play_button_up():
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_credits_button_up():
	pass # Replace with function body.


func _on_exit_button_up():
	pass # Replace with function body.


func _on_back_button_up():
	var scene_path = "res://scenes/menu/menu.tscn"
	get_tree().change_scene_to_file(scene_path)
	



func _on_resolution_button_up():
	get_tree().change_scene_to_file("res://scenes/menu/resolution.tscn")
	
