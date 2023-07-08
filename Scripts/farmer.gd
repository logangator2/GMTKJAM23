extends Node2D

var map_width : int = 20
var map_height : int = 12
var tile_size : int = 64
var farmer_speed : int = 1

var current_location : Vector2

signal killed_weed

func farmer_start():
    print("I am the farmer now.")
    pass
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
    var direction : int
    var new_possible_location : Vector2
    var i_new_possible_location : Vector2i
    while !moved:
        var crop_flag : bool = false
        direction = randi_range(1, 8)
        # Calculate move based on variable
        match (direction):
            1:
                new_possible_location = Vector2(current_farmer_x + farmer_speed, current_farmer_y)
            2:
                new_possible_location = Vector2(current_farmer_x + farmer_speed, current_farmer_y + farmer_speed)
            3:
                new_possible_location = Vector2(current_farmer_x + farmer_speed, current_farmer_y - farmer_speed)
            4:
                new_possible_location = Vector2(current_farmer_x, current_farmer_y + farmer_speed)
            5:
                new_possible_location = Vector2(current_farmer_x, current_farmer_y - farmer_speed)
            6:
                new_possible_location = Vector2(current_farmer_x - farmer_speed, current_farmer_y + farmer_speed)
            7:
                new_possible_location = Vector2(current_farmer_x - farmer_speed, current_farmer_y - farmer_speed)
            8:
                new_possible_location = Vector2(current_farmer_x - farmer_speed, current_farmer_y)
        i_new_possible_location = Vector2i(new_possible_location)
        # Ensures valid dirt space
        var is_dirt : bool = tiles.get_cell_tile_data(0, new_possible_location).get_custom_data("dirt")
        if not new_possible_location in foreground_cells and is_dirt:
            
            #if space is occupied and is not crop
            for plant_location in plant_spaces: # gives each location of player plant
                if i_new_possible_location == plant_location:
                    killed_weed.emit()
                    print("emitted!")
                    current_location = new_possible_location
                    transform.origin = Vector2((new_possible_location[0] * tile_size) + int(tile_size/2),
                    (new_possible_location[1] * tile_size) + int(tile_size/2))
                    moved = true
                    break
            # if space is occupied and now has determined it is not a weed
            for occupied_location in occupied_spaces:
                if i_new_possible_location == occupied_location:
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
        
func get_coords(coordinates):
    current_location = coordinates

# Called when the node enters the scene tree for the first time.
func _ready():
    pass
