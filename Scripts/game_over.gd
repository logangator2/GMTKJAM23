extends Node2D

@export var main_scene:PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
    $TextureRect.set_size(get_viewport().size)
    play_sound()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

# Plays Game Over Sound
func play_sound():
    $GameOverSound.play()

func _on_menu_button_pressed():
    get_tree().change_scene_to_packed(main_scene)

func _on_quit_button_pressed():
    get_tree().quit()
