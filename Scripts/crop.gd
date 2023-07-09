extends Node2D

signal eat_sig

var tile_size : int = 64

var crop_coord : Vector2i

func eat():
	print("eating!")
	eat_sig.emit()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	eat_sig.connect(get_node("/root/test_game/test_tilemap").eat_callable)
	var vec2_coord = transform.origin
	crop_coord = Vector2i(vec2_coord)
	crop_coord -= Vector2i(tile_size/2, tile_size/2)
	crop_coord = crop_coord / Vector2i(tile_size, tile_size)
