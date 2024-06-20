extends CanvasLayer
@onready var inventory = $Inventory
@onready var inventory_button = $UIBarPlaceholder/MarginContainer/HBoxContainer/InventoryButton

@onready var move_counter_label = $MoveCounterLabel
@onready var time_scale_label = $TimeScaleLabel
@onready var future_time_scale_label = $FutureTimeScaleLabel

var player = null

func _ready() -> void:
	pass

func _physics_process(delta):
	var engine_scale = Engine.get_time_scale()
	future_time_scale_label.text = "Time Scale: " + str(engine_scale)

func _on_player_created():
	player = PlayerSingleton.player
	var engine_scale = Engine.get_time_scale()
	time_scale_label.text = "Future Time Scale: " + str(engine_scale)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("letter_i"):
		_toggle_inventory()

func _toggle_inventory() -> void:
	# Toggle the visibility of the inventory
	inventory.visible = !inventory.visible
	# Manually emit the toggled signal to update the button state
	inventory_button.set_pressed(inventory.visible)

func _on_inventory_button_toggled(button_pressed: bool) -> void:
	# Update the visibility based on the button's pressed state
	inventory.visible = button_pressed
	if button_pressed:
		inventory.show()
	else:
		inventory.hide()

func _on_next_button_pressed():
	if not player:
		push_error("No player hooked up to the UI")
		return
	player.next_turn()

func _on_player_move_counter_changed(newNumber):
	move_counter_label.text = "Moves Left: " + str(newNumber)


func _on_player_time_scale_changed(scale):
	time_scale_label.text = "Future Time Scale: " + str(scale)
