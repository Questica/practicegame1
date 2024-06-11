extends Node2D
var height = 40
var width = 40

@onready var dirt_tilemap = $DirtTileMap
@onready var wall_tilemap = $CliffTileMap
@onready var floor_tilemap = $FloorTileMap

const cell_size = Vector2(32, 32)
@onready var map_y = (height * 64) - cell_size.x
@onready var map_x = (width * 64) - cell_size.y
var astar_grid = AStarGrid2D.new()
var grid_size

# Called when the node enters the scene tree for the first time.
func _ready():
	initialize_grid()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func initialize_grid():
	grid_size = Vector2(map_x, map_y) / cell_size
	astar_grid.size = grid_size
	astar_grid.cell_size = cell_size
	astar_grid.offset = cell_size / 2
	astar_grid.update()

func _draw():
	# Draw the grid on the screen
	draw_grid()

func draw_grid():
	# Draw vertical lines for the grid
	#for x in grid_size.x + 1:
		#draw_line(
			#Vector2(x * cell_size.x, 0),  # Start point of the line
			#Vector2(x * cell_size.x, grid_size.y * cell_size.y),  # End point of the line
			#Color.WHITE_SMOKE,  # Color of the line
			#2.0  # Thickness of the line
		#)
	## Draw horizontal lines for the grid
	#for y in grid_size.y + 1:
		#draw_line(
			#Vector2(0, y * cell_size.y),  # Start point of the line
			#Vector2(grid_size.x * cell_size.x, y * cell_size.y),  # End point of the line
			#Color.WHITE_SMOKE,  # Color of the line
			#2.0  # Thickness of the line
		#)
	draw_box(32, 32)

func draw_box(x = 0, y = 0):
	#TOP LINE
	draw_line(
		Vector2(x, y),  # Start point of the line
		Vector2(x + cell_size.x, y),  # End point of the line
		Color.WHITE_SMOKE,  # Color of the line
		2.0  # Thickness of the line
	)
    #RIGHT LINE
	draw_line(
		Vector2(x + cell_size.x, y),  # Start point of the line
		Vector2(x + cell_size.x, cell_size.y + y),  # End point of the line
		Color.WHITE_SMOKE,  # Color of the line
		2.0  # Thickness of the line
	)
	#BOTTOM LINE
	draw_line(
		Vector2(x, y + cell_size.y),  # Start point of the line
		Vector2(x + cell_size.x, y + cell_size.y),  # End point of the line
		Color.WHITE_SMOKE,  # Color of the line
		2.0  # Thickness of the line
	)
	#LEFT LINE
	draw_line(
		Vector2(x, y),  # Start point of the line
		Vector2(x, cell_size.y + y),  # End point of the line
		Color.WHITE_SMOKE,  # Color of the line
		2.0  # Thickness of the line
	)
