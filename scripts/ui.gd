extends CanvasLayer
@onready var inventory = $Inventory
@onready var inventory_button = $UIBarPlaceholder/MarginContainer/HBoxContainer/InventoryButton


func _ready() -> void:
	print(PlayerSingleton.player)

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
	PlayerSingleton.player.next_turn()
