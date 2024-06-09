extends Node2D

@onready var IconRect_path = $Icon

var item_ID : int
var item_grids := []
var selected = false
var grid_anchor = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if selected:
		global_position = lerp(global_position, get_global_mouse_position(), 25 * delta)

func load_item(a_ItemID : int) -> void:
	#match a_ItemID:
		#1:
			#self.set_scale(Vector2(2, 2))
		#2:
			#self.set_scale(Vector2(1, 2))
		#3:
			#self.set_scale(Vector2(2, 1))
		#4:
			#self.set_scale(Vector2(1, 1))
	var Icon_path = "res://assets/ui/" + DataHandler.item_data[str(a_ItemID)]["Name"] + ".png"
	#var Icon_path = "res://assets/ui/test.png"
	IconRect_path.texture = load(Icon_path)
	for grid in DataHandler.item_grid_data[str(a_ItemID)]:
		var converter_array := []
		for i in grid :
			converter_array.push_back(int(i))
		item_grids.push_back(converter_array)
	set_item_size()
	#print(item_grids)

func set_item_size():
	var xMin = 0
	var xMax = 0
	var yMin = 0
	var yMax = 0
	for pos in item_grids:
		if pos[0] > xMax:
			xMax = pos[0]
		if pos[0] < xMin:
			xMin = pos[0]
		if pos[1] > yMax:
			yMax = pos[1]
		if pos[1] < yMin:
			yMin = pos[1]
	print("hello")
	self.set_scale(Vector2(abs(xMax - xMin) + 1, abs(yMax - yMin) + 1))
#rotate 90 degress CW
func rotate_item():
	for grid in item_grids:
		var temp_y = grid[0]
		grid[0] = -grid[1]
		grid[1] = temp_y
	rotation_degrees += 90
	if rotation_degrees>=360:
		rotation_degrees = 0

func _snap_to(destination):
	var tween = get_tree().create_tween()
	#separate cases to avoid snapping errors
	if int(rotation_degrees) % 180 == 0:
		print(IconRect_path.size)
		#destination += IconRect_path.size/2
	else:
		var temp_xy_switch = Vector2(IconRect_path.size.y,IconRect_path.size.x)
		destination += temp_xy_switch/2
	tween.tween_property(self, "global_position", destination, 1).set_trans(Tween.TRANS_SINE)
	selected = false
