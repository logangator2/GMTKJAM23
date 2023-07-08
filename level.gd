extends Node

var map_width : int = 16
var map_height : int = 8

var tile_size : int = 64

@export var tiles : TileMap

@export var player_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var background_cells : Array = tiles.get_used_cells(0)
	var foreground_cells : Array = tiles.get_used_cells(1)
	var player = player_scene.instantiate()
	
	var player_x : int = randi_range(1, map_width - 1)
	var player_y : int = randi_range(1, map_height - 1)

	var player_possible_coord = Vector2i(player_x, player_y)
	if not player_possible_coord in foreground_cells:
		player.transform.origin = Vector2(player_x * tile_size, player_y * tile_size)
		add_child(player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
