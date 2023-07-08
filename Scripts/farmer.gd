extends Node2D

var map_width : int = 20
var map_height : int = 12

var tile_size : int = 64

var current_location : Vector2

var farmer_speed : int = 1

func farmer_start():
    print("I am the farmer now.")
    # Acquire tiles from parent tilemap
    var tile_node = get_parent()
    var tiles = tile_node.get_child(0)
    var foreground_cells : Array = tiles.get_used_cells(1)
    
    # Gets current location (Vector2i coordinates)
    var current_farmer_x = current_location[0]
    var current_farmer_y = current_location[1]
    
    # Make a location the farmer wants to go to
    var moved :bool = false
    var direction : int
    var new_possible_location : Vector2
    while !moved:
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
        # Esnures valid dirt space
        var is_dirt : bool = tiles.get_cell_tile_data(0, new_possible_location).get_custom_data("dirt")
        if not new_possible_location in foreground_cells and is_dirt:
            #testing
            current_location = new_possible_location
            transform.origin = Vector2((new_possible_location[0] * tile_size) + int(tile_size/2),
            (new_possible_location[1] * tile_size) + int(tile_size/2))
            moved = true
            
            #if space is occupied and is not crop
            #if 
                #kill player weed (emit kill signal for player to listen to)
                #move there
                #transform.origin = new_possible_location
                #moved = true
            #if space is not occupied
                #move there3
                #moved = true
        else:
            print("Farmer trying to move again")
        
func get_coords(coordinates):
    current_location = coordinates

# Called when the node enters the scene tree for the first time.
func _ready():
	print(transform)
