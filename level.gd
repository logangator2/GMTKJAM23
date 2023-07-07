extends Node

var map_width : int = 16
var map_height : int = 8

var tile_size : int = 64

@export var player_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	var player = player_scene.instantiate()
	
	var player_x : int = randi_range(1, map_width - 1)
	var player_y : int = randi_range(1, map_height - 1)

	player.transform.origin = Vector2(player_x * tile_size, player_y * tile_size)
	add_child(player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
