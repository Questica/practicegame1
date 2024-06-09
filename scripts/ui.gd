extends CanvasLayer

func _ready() -> void:
	# Enable toggle mode for the button
	$UIBarPlaceholder/InventoryButton.toggle_mode = true
	# Connect the button's "toggled" signal to the method
	$UIBarPlaceholder/InventoryButton.toggled.connect(_on_inventory_button_toggled)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("letter_i"):
		_toggle_inventory()

func _toggle_inventory() -> void:
	# Toggle the visibility of the inventory
	$Inventory.visible = !$Inventory.visible
	# Manually emit the toggled signal to update the button state
	$UIBarPlaceholder/InventoryButton.set_pressed($Inventory.visible)

func _on_inventory_button_toggled(button_pressed: bool) -> void:
	# Update the visibility based on the button's pressed state
	$Inventory.visible = button_pressed
	if button_pressed:
		$Inventory.show()
	else:
		$Inventory.hide()
