extends Node2D

@export var main_scene:PackedScene
@export var level_2:PackedScene
@export var level_3:PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
    $TextureRect.set_size(get_viewport().size)
    play_sound()

# Plays Win Sound
func play_sound():
    $WinSound.play()

func _on_menu_button_pressed():
    get_tree().change_scene_to_packed(main_scene)

func _on_quit_button_pressed():
    get_tree().quit()


func _on_level_3_button_pressed():
    pass # Replace with function body.


func _on_level_2_button_pressed():
    get_tree().change_scene_to_packed(level_2)
