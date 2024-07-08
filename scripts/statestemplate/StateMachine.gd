extends Node

@export var initial_state : State
@export var player : CharacterBody2D

var states : Dictionary = {}
var current_state : State

signal StateMachineTransitioned

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
	if initial_state:
		initial_state.Enter()
		current_state = initial_state

func _process(delta):
	if current_state:
		current_state.Update(delta)

func _physics_process(delta):
	if current_state:
		current_state.Physics_Update(delta)

func on_child_transition(state, new_state_name, args=null):
	if player.move_counter <= 0 and new_state_name != "playerIdle":
		return
	if state != current_state:
		return
	var new_state = states.get(new_state_name.to_lower())
	if !new_state or new_state == state:
		return
	if current_state:
		current_state.Exit()
	if args:
		new_state.Enter(args)
	else:
		new_state.Enter()
	current_state = new_state
	
	StateMachineTransitioned.emit(new_state)

func transition_to(new_state_name, args=null):
	on_child_transition(current_state, new_state_name, args)

func get_current_state():
	return current_state
