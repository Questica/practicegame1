extends CharacterBody2D

@export var map_generator: Node
@onready var world_tile_map = map_generator.get_node("WorldTileMap")

@onready var player_state_machine = get_node("PlayerStateMachine")

#@onready var move_tween = create_tween()
var move_counter_start = 4
var move_counter = move_counter_start
var move_tween : Tween

signal move_counter_changed(newNumber: int)
signal player_created()
signal time_scale_changed(scale: int)


func _ready():
	Engine.time_scale = 0.5
	self.set_position((map_generator.dirt[0] * 32) + Vector2i(16, 16))
	PlayerSingleton.player = self
	player_created.emit()
	move_counter_changed.emit(move_counter_start)

func _input(event):
	if Input.is_action_just_released("mouse_leftclick"):
		var mouse_pos = get_global_mouse_position()
		var tile = Vector2i(floor(mouse_pos / 32))
		player_state_machine.get_current_state().mouse_down(tile)

func subtract_move_counter(number: int):
	set_move_counter(move_counter-number)

func set_move_counter(number: int):
	move_counter = number
	move_counter_changed.emit(move_counter)

func reset_move_counter():
	set_move_counter(move_counter_start)

func next_turn():
	if move_counter <= 0:
		await slow_time()
		reset_move_counter()
		return true
	return false

func slow_time():
	var number = RandomNumberGenerator.new().randf_range(.5, 5)
	print(number)
	
	var tween = get_tree().create_tween()
	#tween.set_speed_scale(1.0 / Engine.time_scale)
	# Speed up the time scale to 1.0 over 1 second
	tween.tween_property(Engine, "time_scale", number, 3).set_trans(Tween.TRANS_SINE)
	time_scale_changed.emit(number)
	## Wait for 1 second
	#tween.tween_interval(1.0)
	## Slow down the time scale back to 0.5 over 1 second
	#tween.tween_property(Engine, "time_scale", 0.5, 1.0).set_trans(Tween.TRANS_SINE)
	#time_scale_changed.emit(0.5)


func _on_player_state_machine_state_machine_transitioned(new_state : State):
	if new_state.name.to_lower() == "playeridle":
		return
	subtract_move_counter(1)
