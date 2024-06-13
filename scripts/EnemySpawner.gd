extends Node2D

func _ready():
	$Timer.wait_time = 0.5
	$Timer.start()

func spawn_bat():
	var new_bat = preload("res://scenes/enemy_test.tscn").instantiate()
	new_bat.global_position = Vector2.ZERO
	add_child(new_bat)

func _on_timer_timeout() -> void:
	spawn_bat()
