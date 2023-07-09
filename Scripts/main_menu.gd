extends Node

@export var play_scene:PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureRect.set_size(get_viewport().size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $AudioStreamPlayer2D.playing == false:
		$AudioStreamPlayer2D.play()

func _on_play_button_pressed():
	get_tree().change_scene_to_packed(play_scene)

func _on_quit_button_pressed():
	get_tree().quit()
