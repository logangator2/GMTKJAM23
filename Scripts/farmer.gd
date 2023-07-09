extends Node2D

var map_width : int = 20
var map_height : int = 12
var tile_size : int = 64
var farmer_speed : int = 1

var current_location : Vector2

signal killed_weed

func farmer_start():
    print("I am the farmer now.")
    # Acquire tiles from parent tilemap
    var tile_node = get_parent()
    var tiles = tile_node.get_child(0)
    var foreground_cells : Array = tiles.get_used_cells(1)
    
    var occupied_spaces : Array = tile_node.occupied_spaces
    var plant_spaces : Array = tile_node.plant_spaces
    
    # Gets current location (Vector2i coordinates)
    var current_farmer_x = current_location[0]
    var current_farmer_y = current_location[1]
    
    # Make a location the farmer wants to go to
    var moved :bool = false
    var new_possible_location : Vector2i
    tile_node.occupied_spaces.erase(Vector2i(current_location))
    var direction_vectors = [
            Vector2i(-1,-1), Vector2i(0,-1), Vector2i(1,-1),
            Vector2i(-1,0), 				Vector2i(1,0),
            Vector2i(-1,1), Vector2i(0, 1), Vector2i(1,1)]
    var plant_sum : Vector2i = Vector2i(0,0)
    for plant in tile_node.plant_spaces:
        plant_sum += plant
    var plant_avg = plant_sum / tile_node.plant_spaces.size()
    print(plant_avg)
    print(current_location)
    
    var plant_avg_x : int = plant_avg.x
    var plant_avg_y : int = plant_avg.y
    
    var biases : Array = []
    
    if plant_avg_x < current_farmer_x:
        biases.append("left")
    if plant_avg_y < current_farmer_y:
        biases.append("up")
    if plant_avg_x > current_farmer_x:
        biases.append("right")
    if plant_avg_y > current_farmer_y:
        biases.append("down")
    
    print(biases)
    
    var good_directions : Array = []
    
    for bias in biases:
        match bias:
            "left":
                good_directions.append(direction_vectors[0])
                good_directions.append(direction_vectors[3])
                good_directions.append(direction_vectors[5])
            "right":
                good_directions.append(direction_vectors[2])
                good_directions.append(direction_vectors[4])
                good_directions.append(direction_vectors[7])
            "up":
                good_directions.append(direction_vectors[0])
                good_directions.append(direction_vectors[1])
                good_directions.append(direction_vectors[2])
            "down":
                good_directions.append(direction_vectors[5])
                good_directions.append(direction_vectors[6])
                good_directions.append(direction_vectors[7])

    while !moved:
        var crop_flag : bool = false
        var dir_idx : int = randi_range(0, good_directions.size() - 1)
        new_possible_location = Vector2i(current_location) + good_directions[dir_idx]

        var is_dirt : bool = tiles.get_cell_tile_data(0, new_possible_location).get_custom_data("dirt")
        if not new_possible_location in foreground_cells and is_dirt:
            
            #if space is occupied and is not crop
            for plant_location in plant_spaces: # gives each location of player plant
                if new_possible_location == plant_location:
                    killed_weed.emit(plant_location)
                    print("emitted!")
                    if plant_spaces.size() == 0:
                        get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
                    current_location = new_possible_location
                    transform.origin = Vector2((new_possible_location[0] * tile_size) + int(tile_size/2),
                    (new_possible_location[1] * tile_size) + int(tile_size/2))
                    moved = true
                    break
            # if space is occupied and now has determined it is not a weed
            for occupied_location in occupied_spaces:
                if new_possible_location == occupied_location:
                    print("Uh-oh! This is my crop.")
                    crop_flag = true
                    break
            if crop_flag:
                continue
            else:
                current_location = new_possible_location
                transform.origin = Vector2((new_possible_location[0] * tile_size) + int(tile_size/2),
                (new_possible_location[1] * tile_size) + int(tile_size/2))
                moved = true
        else:
            print("Farmer trying to move again")
    tile_node.occupied_spaces.append(Vector2i(new_possible_location))
    biases.clear()
    print(biases)
        
func get_coords(coordinates):
    current_location = coordinates
    
func play_sound():
    $UprootAudio.play()

# Called when the node enters the scene tree for the first time.
func _ready():
    killed_weed.connect(get_parent().attack_callable)
