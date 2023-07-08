extends Node2D

signal place_plant_sig

# Called when the node enters the scene tree for the first time.
func _ready():
	#place_plant_sig.connect("root/test_game/test_tilemap").place_callable
	pass


func _on_button_pressed():
	place_plant_sig.emit()
