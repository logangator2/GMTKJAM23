extends Node2D

signal plant_sig

func plant():
    print("planting!")
    plant_sig.emit()

func protect():
    print("protecting!")
    
func eat():
    print("eating!")
    
# Called when the node enters the scene tree for the first time.
func _ready():
    print(get_node("/root/test_game/test_tilemap").plant_callable)
    plant_sig.connect(get_node("/root/test_game/test_tilemap").plant_callable)
    print(transform)
