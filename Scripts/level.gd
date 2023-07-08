extends Node

var map_width : int = 20
var map_height : int = 12

var tile_size : int = 64

@export var tiles : TileMap

@export var player_scene: PackedScene
@export var crop_scene: PackedScene

func set_player_start():
	var foreground_cells : Array = tiles.get_used_cells(1)
	var player = player_scene.instantiate()
	
	var spawned : bool = false

	while !spawned:
		var player_x : int = randi_range(1, map_width - 3)
		var player_y : int = randi_range(1, map_height - 3)

		var player_possible_coord = Vector2i(player_x, player_y)
extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	print(transform)
	add_to_group("self")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		var is_dirt : bool = tiles.get_cell_tile_data(0, player_possible_coord).get_custom_data("dirt")
		if not player_possible_coord in foreground_cells and is_dirt:
			player.transform.origin = Vector2((player_x * tile_size) + int(tile_size/2), (player_y * tile_size) + int(tile_size/2))
			add_child(player)
			spawned = true
		else:
			print("try again player")
			


func spawn_level_crops():
	var foreground_cells : Array = tiles.get_used_cells(1)
	var crop = crop_scene.instantiate()
	

	var spawned : bool = false
	while !spawned:
		var crop_x : int = randi_range(1, map_width - 3)
		var crop_y : int = randi_range(1, map_height - 3)
		
		var crop_possible_coord = Vector2i(crop_x, crop_y)
		var is_dirt : bool = tiles.get_cell_tile_data(0, crop_possible_coord).get_custom_data("dirt")
		if (not crop_possible_coord in foreground_cells) and is_dirt:
			crop.transform.origin = Vector2((crop_x * tile_size) + int(tile_size/2), (crop_y * tile_size) + int(tile_size/2))
			add_child(crop)
			spawned = true
		else:
			print("try again crop")


# Called when the node enters the scene tree for the first time.
func _ready():
	set_player_start()
	for i in range(4):
		spawn_level_crops()
