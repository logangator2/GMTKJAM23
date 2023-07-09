extends Node

var map_width : int = 20
var map_height : int = 12

var tile_size : int = 64

@export var tiles : TileMap

@export var player_scene: PackedScene
@export var crop_scene: PackedScene
@export var farmer_scene: PackedScene
@export var highlight_scene: PackedScene
@export var protect_highlight_scene: PackedScene
@export var eat_highlight_scene: PackedScene
@export var game_over_scene: PackedScene


var occupied_spaces : Array = []
var plant_spaces : Array = []
var crop_spaces : Array = []

var plant_callable
var place_callable
var protect_callable
var fortify_callable
var attack_callable
var eat_callable
var crop_callable

func set_player_start():
	var foreground_cells : Array = tiles.get_used_cells(1)
	var player = player_scene.instantiate()
	
	var spawned : bool = false

	while !spawned:
		var player_x : int = randi_range(1, map_width - 3)
		var player_y : int = randi_range(1, map_height - 3)

		var player_possible_coord = Vector2i(player_x, player_y)

		var is_dirt : bool = tiles.get_cell_tile_data(0, player_possible_coord).get_custom_data("dirt")
		if (not player_possible_coord in foreground_cells) and is_dirt and (not player_possible_coord in occupied_spaces):
			player.transform.origin = Vector2((player_x * tile_size) + int(tile_size/2), (player_y * tile_size) + int(tile_size/2))
			add_child(player)
			occupied_spaces.append(player_possible_coord)
			plant_spaces.append(player_possible_coord)
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
		if (not crop_possible_coord in foreground_cells) and is_dirt and (not crop_possible_coord in occupied_spaces):
			crop.transform.origin = Vector2((crop_x * tile_size) + int(tile_size/2), (crop_y * tile_size) + int(tile_size/2))
			add_child(crop)
			occupied_spaces.append(crop_possible_coord)
			crop_spaces.append(crop_possible_coord)
			spawned = true
		else:
			print("try again crop")


# Spawns farmer in an area that is unoccupied
func spawn_level_farmer():
	var foreground_cells : Array = tiles.get_used_cells(1)
	var farmer = farmer_scene.instantiate()
	var spawned : bool = false
	
	while !spawned:
		var farmer_x : int = randi_range(1, map_width - 3)
		var farmer_y : int = randi_range(1, map_height - 3)
		
		var farmer_possible_coord = Vector2i(farmer_x, farmer_y)
		var is_dirt : bool = tiles.get_cell_tile_data(0, farmer_possible_coord).get_custom_data("dirt")
		if (not farmer_possible_coord in foreground_cells) and is_dirt and (not farmer_possible_coord in occupied_spaces):
			farmer.transform.origin = Vector2((farmer_x * tile_size) + int(tile_size/2), (farmer_y * tile_size) + int(tile_size/2))
			add_child(farmer)
			spawned = true
			farmer.get_coords(farmer_possible_coord)
			occupied_spaces.append(farmer_possible_coord)
		else:
			print("try again farmer")

func spawn_highlight(highlight_coord : Vector2i):
	var highlight = highlight_scene.instantiate()
	var highlight_x = highlight_coord.x
	var highlight_y = highlight_coord.y
	highlight.transform.origin = Vector2((highlight_x * tile_size) + int(tile_size/2), (highlight_y * tile_size) + int(tile_size/2))
	add_child(highlight)
	
func spawn_protect_highlight(highlight_coord : Vector2i):
	var highlight = protect_highlight_scene.instantiate()
	var highlight_x = highlight_coord.x
	var highlight_y = highlight_coord.y
	highlight.transform.origin = Vector2((highlight_x * tile_size) + int(tile_size/2), (highlight_y * tile_size) + int(tile_size/2))
	add_child(highlight)
	
func spawn_eat_highlight(highlight_coord : Vector2i):
	var highlight = eat_highlight_scene.instantiate()
	var highlight_x = highlight_coord.x
	var highlight_y = highlight_coord.y
	highlight.transform.origin = Vector2((highlight_x * tile_size) + int(tile_size/2), (highlight_y * tile_size) + int(tile_size/2))
	add_child(highlight)
	
func plant_action():
	var foreground_cells : Array = tiles.get_used_cells(1)
	var direction_vectors = [
		Vector2i(-1,-1), Vector2i(0,-1), Vector2i(1,-1),
		Vector2i(-1,0), 				Vector2i(1,0),
		Vector2i(-1,1), Vector2i(0, 1), Vector2i(1,1)]
	var eligible_spaces : Array = []
	print(plant_spaces)
	for plant_i in plant_spaces:
		for direction_j in direction_vectors:
			var is_dirt : bool = tiles.get_cell_tile_data(0, plant_i).get_custom_data("dirt")
			var potential_space = plant_i + direction_j
			if (potential_space not in foreground_cells) and is_dirt and (potential_space not in occupied_spaces):
				eligible_spaces.append(potential_space)
	for space in eligible_spaces:
		spawn_highlight(space)


func place_plant(new_location : Vector2i):
	var new_plant = player_scene.instantiate()
	var new_plant_x = new_location.x
	var new_plant_y = new_location.y
	new_plant.transform.origin = Vector2((new_plant_x * tile_size) + int(tile_size/2), (new_plant_y * tile_size) + int(tile_size/2))
	add_child(new_plant)
	new_plant.play_sound()
	occupied_spaces.append(new_location)
	plant_spaces.append(new_location)
	
	for highlight in get_tree().get_nodes_in_group("highlight"):
		highlight.queue_free()
		

func protect_plant(plant_location : Vector2i):
	for plant in get_tree().get_nodes_in_group("player"):
		if plant.plant_coord == plant_location:
			plant.resiliance += 1
	
	for highlight in get_tree().get_nodes_in_group("highlight"):
		highlight.queue_free()

func protect_action():
	for plant in plant_spaces:
		spawn_protect_highlight(plant)
		
func farmer_attack(plant_location : Vector2i):
	for plant in get_tree().get_nodes_in_group("player"):
		if plant.plant_coord == plant_location:
			plant.resiliance -= 1
			
			if plant.resiliance == 0:
				occupied_spaces.erase(plant.plant_coord)
				plant_spaces.erase(plant.plant_coord)
				plant.queue_free()
				get_tree().get_first_node_in_group("farmer").play_sound()
	

func eat_crop(crop_location : Vector2i):
	for crop in get_tree().get_nodes_in_group("crop"):
		if crop.crop_coord == crop_location:
			occupied_spaces.erase(crop.crop_coord)
			crop_spaces.erase(crop.crop_coord)
			crop.queue_free()
			get_tree().get_first_node_in_group("farmer").play_sound()
	
	for highlight in get_tree().get_nodes_in_group("highlight"):
		highlight.queue_free()

func eat_action():
	var foreground_cells : Array = tiles.get_used_cells(1)
	var direction_vectors = [
		Vector2i(-1,-1), Vector2i(0,-1), Vector2i(1,-1),
		Vector2i(-1,0), 				Vector2i(1,0),
		Vector2i(-1,1), Vector2i(0, 1), Vector2i(1,1)]
	var eligible_spaces : Array = []
	print(plant_spaces)
	for plant_i in plant_spaces:
		for direction_j in direction_vectors:
			var is_dirt : bool = tiles.get_cell_tile_data(0, plant_i).get_custom_data("dirt")
			var potential_space = plant_i + direction_j
			if potential_space in crop_spaces:
				eligible_spaces.append(potential_space)
	for space in eligible_spaces:
		spawn_eat_highlight(space)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	plant_callable = Callable(self, "plant_action")
	place_callable = Callable(self, "place_plant")
	protect_callable = Callable(self, "protect_action")
	fortify_callable = Callable(self, "protect_plant")
	attack_callable = Callable(self, "farmer_attack")
	eat_callable = Callable(self, "eat_action")
	crop_callable = Callable(self, "eat_crop")
	
	set_player_start()
	for i in range(4):
		spawn_level_crops()
	spawn_level_farmer()

