extends Node2D

signal eat_crop_sig

var tile_size : int = 64

var highlight_coords : Vector2i
var clicked_coords : Vector2i = Vector2i(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
    eat_crop_sig.connect(get_parent().crop_callable)
    var vec2_coord = transform.origin
    highlight_coords = Vector2i(vec2_coord)
    highlight_coords -= Vector2i(tile_size/2, tile_size/2)
    highlight_coords = highlight_coords / Vector2i(tile_size, tile_size)


func _on_button_pressed():
    clicked_coords = highlight_coords
    eat_crop_sig.emit(clicked_coords)
    # Test for no more crops
    var tile_node = get_parent()
    var crop_spaces : Array = tile_node.crop_spaces
    if crop_spaces.size() == 0:
        get_tree().change_scene_to_file("res://Scenes/win.tscn")
