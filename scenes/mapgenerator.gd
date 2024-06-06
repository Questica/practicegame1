extends Node2D

@onready var dirt_tilemap = $DirtTileMap
@onready var wall_tilemap = $CliffTileMap

var rng = RandomNumberGenerator.new()

var cell_size = Vector2(16, 16)
var width = (1024 / cell_size.x)
var height = (768 / cell_size.y)
var grid = []
var walkers = []

class Walker:
	var dir: Vector2
	var pos: Vector2

var max_iterations = 1000

var walker_max_count = 3
var walker_spawn_chance = 0.25
var walker_direction_chance = 0.5
var fill_percent = 0.3
var walker_destroy_chance = 0.2

var Tiles = {
	"empty": -1,
	"wall": 0,
	"floor": 1
}

func init_walkers():
	walkers = []
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

			if (walkers[i].pos.x + walkers[i].dir.x >= 0 and 
				walkers[i].pos.x + walkers[i].dir.x < width and
				walkers[i].pos.y + walkers[i].dir.y >= 0 and
				walkers[i].pos.y + walkers[i].dir.y < height):

					walkers[i].pos += walkers[i].dir
					if grid[walkers[i].pos.x][walkers[i].pos.y] == Tiles.empty:
						grid[walkers[i].pos.x][walkers[i].pos.y] = Tiles.floor
						n_tiles += 1

					if float(n_tiles)/float(width*height) >= fill_percent:
						return
		itr += 1

func spawn_tiles():
	var cells = []
	for x in range(width):
		for y in range(height):
			match grid[x][y]:
				Tiles.empty:
					pass
				Tiles.floor:
					cells.append(Vector2(x, y))
					print("Placing floor tile at: %s, " % x, y)  # Debug print
					dirt_tilemap.set_cells_terrain_connect(0, cells, 0, 0)
				Tiles.wall:
					pass

func clear_tilemaps():
	dirt_tilemap.clear()
	wall_tilemap.clear()

func _ready():
	rng.randomize()
	init_walkers()
	init_grid()
	clear_tilemaps()
	create_random_path()
	spawn_tiles()

#extends Node2D
#
#@onready var tilemap = $TileMap
#
#const MAP_SIZE = Vector2(512, 512)
#const LAND_CAP = 0.1
#
#func _ready():
	#generate_world()
#
#func generate_world():
	#var noise = FastNoiseLite.new()
	#noise.seed = 100 #randi()
	#
	#var cells = []
	#for x in MAP_SIZE.x:
		#for y in MAP_SIZE.y:
			#var a = noise.get_noise_2d(x, y)
			#if a < LAND_CAP:
				#cells.append(Vector2(x, y))
			#else:
				#tilemap.set_cell(0, Vector2(x, y), 0, Vector2(0, 5), 0)
	#
	#tilemap.set_cells_terrain_connect(0, cells, 0, 0)
