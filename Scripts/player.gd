extends Node2D

signal plant_sig
signal protect_sig

var tile_size : int = 64

var plant_coord : Vector2i
var resiliance : int = 1

func plant():
    print("planting!")
    plant_sig.emit()

func protect():
    print("protecting!")
    protect_sig.emit()
    

    
func play_sound():
    $PlantingAudio.play()

# Called when the node enters the scene tree for the first time.
func _ready():
    plant_sig.connect(get_node("/root/test_game/test_tilemap").plant_callable)
    protect_sig.connect(get_node("/root/test_game/test_tilemap").protect_callable)
    var vec2_coord = transform.origin
    plant_coord = Vector2i(vec2_coord)
    plant_coord -= Vector2i(tile_size/2, tile_size/2)
    plant_coord = plant_coord / Vector2i(tile_size, tile_size)
