extends Node2D

signal place_plant_sig

var tile_size : int = 64

var highlight_coords : Vector2i
var clicked_coords : Vector2i = Vector2i(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
    place_plant_sig.connect(get_parent().place_callable)
    var vec2_coord = transform.origin
    highlight_coords = Vector2i(vec2_coord)
    highlight_coords -= Vector2i(tile_size/2, tile_size/2)
    highlight_coords = highlight_coords / Vector2i(tile_size, tile_size)


func _on_button_pressed():
    clicked_coords = highlight_coords
    place_plant_sig.emit(clicked_coords)
