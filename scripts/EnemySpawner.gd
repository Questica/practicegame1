extends Node2D

func _ready():
	$Timer.wait_time = 0.5
	$Timer.start()

func spawn_bat():
	var new_bat = preload("res://scenes/enemy_test.tscn").instantiate()
	new_bat.global_position = random_spawn_position()
	add_child(new_bat)

func random_spawn_position() -> Vector2:
	var map_size = $"../MapGenerator".camera_setup()
	var edge = randi_range(1, 4)
	var x = randi_range(0, map_size[0] * 32)
	var y = randi_range(0, map_size[1] * 32)
	if edge == 1:
		return Vector2(x, 0)
	elif edge == 2:
		return Vector2(x, map_size[1] * 32)
	elif edge == 3:
		return Vector2(0, y)
	elif edge == 4:
		return Vector2(map_size[0] * 32, y)
	else:
		return Vector2.ZERO

func _on_timer_timeout() -> void:
	spawn_bat()
