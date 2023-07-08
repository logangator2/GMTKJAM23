extends Node2D

func plant():
    print("planting!")

func protect():
	print("protecting!")

func eat():
	print("eating!")

# Called when the node enters the scene tree for the first time.
func _ready():
    print(transform)
