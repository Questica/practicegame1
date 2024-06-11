extends Node2D

@onready var dirt_tilemap = $DirtTileMap
@onready var wall_tilemap = $CliffTileMap
@onready var floor_tilemap = $FloorTileMap
@onready var map_y = (height * 64) - 32
@onready var map_x = (width * 64) - 32

@export var height : int
@export var width : int

var rng = RandomNumberGenerator.new()

const cell_size = Vector2(32, 32)

var grid = []
var walkers = []

class Walker:
	var dir: Vector2
	var pos: Vector2

var max_iterations = 100000

var walker_max_count = 3
var walker_spawn_chance = 0.25
var walker_direction_chance = 0.5
var fill_percent = 0.45
var walker_destroy_chance = 0.2

var neighbors4 = [ [1, 0], [-1, 0], [0, 1], [0, -1]]
var neighbors8 = [ [1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [-1, -1], [1, -1], [-1, 1]]

enum Tiles {
	EMPTY = -1,
	WALL = 0,
	FLOOR = 1,
	DIRT = 2,
}

var walls = []
var dirt = []
var floors = []


func init_walkers():
	var walker = Walker.new()
	walker.dir = get_random_direction()
	walker.pos = Vector2(width/2, height/2)
	walkers.append(walker)

func init_grid():
	grid = []
	for x in width:
		grid.append([])
		for y in height:
			grid[x].append(-1);

func get_random_direction():
	var directions = [[-1, 0], [1, 0], [0, 1], [0, -1]]
	var direction = directions[rng.randi() % 4]
	return Vector2(direction[0], direction[1])
	
func create_random_path():
	var itr = 0
	var n_tiles = 0
	
	while itr < max_iterations:
		# Change direction, with chance
		for i in range(walkers.size()):
			if rng.randf() < walker_direction_chance:
				walkers[i].dir = get_random_direction()

		# Random: Maybe destroy walker?
		for i in range(walkers.size()):
			if rng.randf() < walker_destroy_chance and walkers.size() > 1:
				walkers.remove_at(i);
				break; # Destroy only one walker per iteration

		# Spawn new walkers, with chance
		for i in range(walkers.size()):
			if rng.randf() < walker_spawn_chance and walkers.size() < walker_max_count:
				var walker = Walker.new()
				walker.dir = get_random_direction()
				walker.pos = walkers[i].pos
				walkers.append(walker)

		# Advance walkers
		for i in range(walkers.size()):

			if (walkers[i].pos.x + walkers[i].dir.x >= 1 and 
				walkers[i].pos.x + walkers[i].dir.x < width-1 and
				walkers[i].pos.y + walkers[i].dir.y >= 1 and
				walkers[i].pos.y + walkers[i].dir.y < height-1):

					walkers[i].pos += walkers[i].dir
					if grid[walkers[i].pos.x][walkers[i].pos.y] == Tiles.EMPTY:
						grid[walkers[i].pos.x][walkers[i].pos.y] = Tiles.FLOOR
						n_tiles += 1

					if float(n_tiles)/float(width*height) >= fill_percent:
						return
		itr += 1

func create_walls():
	
	for x in width:
		for y in height:
			if grid[x][y] == Tiles.FLOOR:
				for neighbor in neighbors4:
					if check_bounds(x, y, neighbor) && grid[x + neighbor[0]][y + neighbor[1]] == Tiles.EMPTY:
						grid[x + neighbor[0]][y + neighbor[1]] = Tiles.WALL

func remove_singletons():
	for x in width:
		for y in height:
			if grid[x][y] == Tiles.WALL:
				var single = true
				for neighbor in neighbors4:
					if check_bounds(x, y, neighbor) && grid[x + neighbor[0]][y + neighbor[1]] != Tiles.FLOOR:
						single = false
						break
				if single:
					grid[x][y] = Tiles.FLOOR

func check_bounds(x, y, neighbor):
	return x + neighbor[0] >= 0 && y + neighbor[1] >= 0 && y + neighbor[1] < height && x + neighbor[0] < width

func pad_dirt():

	var bfs = []
	var visited = []
	var pos = null
	for x in width:
		visited.append([])
		for y in height:
			if grid[x][y] == Tiles.WALL:
				bfs.append(Vector2(x, y))
				visited[x].append(0)
			else:
				visited[x].append(60000)

	while !bfs.is_empty():
		pos = bfs.pop_front()
		for i in range(neighbors8.size()):
			var next = Vector2(pos.x + neighbors8[i][0], pos.y + neighbors8[i][1])
			if next.x >= 1 and next.x < width-1 and next.y >= 1 and next.y < height-1 and (
				visited[next.x][next.y] == 60000
				):
				visited[next.x][next.y] = visited[pos.x][pos.y] + 1
				bfs.append(next)    

	for x in width:
		for y in height:
			if x == 0 or y == 0 or x == width-1 or y == height-1:
				continue
			if grid[x][y] == Tiles.FLOOR and visited[x][y] >= 2:
				grid[x][y] = Tiles.DIRT
		
func remove_diagonals(tile_index):
	var pos = null
	for x in width:
		for y in height:
			# Check if on edges
			if x == 0 or y == 0 or x == width-1 or y == height-1:
				continue

		# If not on edges, make sure all surrounding tiles are FLOOR and this is wall
			pos = Vector2(x, y);
			if grid[pos.x][pos.y] == tile_index:
				if (grid[pos.x - 1][pos.y] == Tiles.FLOOR and grid[pos.x + 1][pos.y] == Tiles.FLOOR and
					grid[pos.x][pos.y - 1] == Tiles.FLOOR and grid[pos.x][pos.y + 1] == Tiles.FLOOR):
					grid[pos.x][pos.y] = Tiles.FLOOR

				# Check if diagonal tile
				if (grid[pos.x - 1][pos.y] == Tiles.FLOOR and grid[pos.x][pos.y-1] == Tiles.FLOOR and
					grid[pos.x - 1][pos.y-1] == tile_index) or (grid[pos.x + 1][pos.y] == Tiles.FLOOR and grid[pos.x][pos.y+1] == Tiles.FLOOR and
					grid[pos.x + 1][pos.y+1] == tile_index) or (grid[pos.x + 1][pos.y] == Tiles.FLOOR and grid[pos.x][pos.y-1] == Tiles.FLOOR and
					grid[pos.x + 1][pos.y-1] == tile_index) or (grid[pos.x - 1][pos.y] == Tiles.FLOOR and grid[pos.x][pos.y+1] == Tiles.FLOOR and
					grid[pos.x - 1][pos.y+1] == tile_index):
					grid[pos.x][pos.y] = Tiles.FLOOR

func spawn_tiles():
	for x in range(width):
		for y in range(height):
			match grid[x][y]:
				Tiles.EMPTY:
					walls.append(Vector2i(x, y))
					#print("Placing empty tile at: %s, " % x, y)  # Debug print
				Tiles.FLOOR:
					floors.append(Vector2i(x, y))
				Tiles.DIRT:
					dirt.append(Vector2i(x, y))
					floors.append(Vector2i(x, y))
					#print("Placing dirt tile and path tile at: %s, " % x, y)  # Debug print
				Tiles.WALL:
					walls.append(Vector2i(x, y))
					#print("Placing wall tile at: %s, " % x, y)  # Debug print
	floor_tilemap.set_cells_terrain_connect(0, floors, 0, 0)
	dirt_tilemap.set_cells_terrain_connect(0, dirt, 0, 0, false)
	wall_tilemap.set_cells_terrain_connect(0, walls, 0, 0)

func clear_tilemaps():
	dirt_tilemap.clear()
	wall_tilemap.clear()

func _draw():
	for x in floors:
		draw_box(x)
	for x in dirt:
		draw_box(x)

#func draw_grid():
	## Draw vertical lines for the grid
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

func generate_map():
	rng.randomize()
	#rng.seed = 50
	init_walkers()
	init_grid()
	clear_tilemaps()
	create_random_path()
	create_walls()
	remove_singletons()
	pad_dirt()
	remove_diagonals(Tiles.DIRT)
	spawn_tiles()

func draw_box(box: Vector2):
	var x = box[0] * cell_size.x
	var y = box[1] * cell_size.y
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


func _ready():
	print(map_y)
	%Background.region_rect.size.y = map_y
	%Background.region_rect.size.x = map_x
	$Camera2D.limit_bottom = height * 32
	$Camera2D.limit_right = width * 32
	# set the camera position, later we will intialize this to the player's starting position
	$Camera2D.position = Vector2(320.0, 180.0)
	generate_map()
