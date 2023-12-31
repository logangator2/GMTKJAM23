extends Node2D

var turn_counter = 1

var intruction_flag : bool = true

var action_array = ["Plant", "Plant", "Plant", "Plant", "Plant", 
"Protect", "Protect", "Protect", "Eat", "Eat"]

var action_1_used = false
var action_2_used = false

@export var map_scene: PackedScene

@export var farmer_moves = 1

@export var Action_1:Button
@export var Action_2:Button

# Called when the node enters the scene tree for the first time.
func _ready():
    randomize()
    var map = map_scene.instantiate()
    add_child(map)
    # Shuffle actions, make sure eat is not in first 'hand'
    action_array.shuffle()
    while (action_array[0] == "Eat") or (action_array[1] == "Eat") or (action_array[2] == "Eat"):
        action_array.shuffle()
        print("try again shuffle 1")
        
    # Create Button Names
    Action_1.text = action_array[0]
    Action_2.text = action_array[1]


func _input(event):
    if (Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and intruction_flag:
        $in_game_ui/InstructionContainer.hide()
        $in_game_ui/Tutorial.hide()
        intruction_flag = false
    if (Input.is_action_just_pressed("Mute")):
        var bus_index = AudioServer.get_bus_index("Master")
        AudioServer.set_bus_mute(bus_index, true)
    if (Input.is_action_just_pressed("Action_1") and not Action_1.disabled):
        _on_action_1_pressed()
    if (Input.is_action_just_pressed("Action_2") and not Action_2.disabled):
        _on_action_2_pressed()
    if (Input.is_action_just_pressed("End_Turn")):
        _on_end_turn_button_pressed()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if $in_game_ui/InstructionContainer/GameMusic.playing == false:
        $in_game_ui/InstructionContainer/GameMusic.play()

# Handle a new turn
func new_turn():
    print("Starting turn %d" % turn_counter)
    
    # Shuffle Actions
    action_array.shuffle()
    
    # Reset Button Names
    Action_1.text = action_array[0]
    Action_2.text = action_array[1]
    
    Action_1.disabled = false
    Action_2.disabled = false
    
    # Reset Button Uses
    action_1_used = false
    action_2_used = false
    
func check_actions():
    if Action_1.disabled and Action_2.disabled:
        var new_stylebox_normal = $in_game_ui/UIBackground/GameUI/RightCenterContainer/HBoxContainer/EndTurnButton.get_theme_stylebox("normal").duplicate()
        new_stylebox_normal.border_width_top = 3
        new_stylebox_normal.border_width_bottom = 3
        new_stylebox_normal.border_width_left = 3
        new_stylebox_normal.border_width_right = 3
        new_stylebox_normal.border_color = Color(.59,1,.42,1)
        $in_game_ui/UIBackground/GameUI/RightCenterContainer/HBoxContainer/EndTurnButton.add_theme_stylebox_override("normal", new_stylebox_normal)


# Handles when end turn button is pressed
func _on_end_turn_button_pressed():
    var new_stylebox_normal = $in_game_ui/UIBackground/GameUI/RightCenterContainer/HBoxContainer/EndTurnButton.get_theme_stylebox("normal").duplicate()
    new_stylebox_normal.border_width_top = 0
    new_stylebox_normal.border_width_bottom = 0
    new_stylebox_normal.border_width_left = 0
    new_stylebox_normal.border_width_right = 0
    new_stylebox_normal.border_color = Color(.59,1,.42,1)
    $in_game_ui/UIBackground/GameUI/RightCenterContainer/HBoxContainer/EndTurnButton.add_theme_stylebox_override("normal", new_stylebox_normal)

    # Increment turn counter
    print("Turn Ended")
    turn_counter += 1
    # Trigger farmer actions
    for i in range(farmer_moves):
        get_tree().get_first_node_in_group("farmer").farmer_start()
    # Call new turn
    new_turn()
    

func _on_action_1_pressed():
    print(Action_1.text)
    action_1_used = true
    if Action_1.text == "Plant":
        get_tree().get_first_node_in_group("player").plant()
        
    if Action_1.text == "Protect":
        get_tree().get_first_node_in_group("player").protect()
        
    if Action_1.text == "Eat":
        get_tree().get_first_node_in_group("crop").eat()
        
    Action_1.disabled = true
    check_actions()


func _on_action_2_pressed():
    print(Action_2.text)
    action_2_used = true
    if Action_2.text == "Plant":
        get_tree().get_first_node_in_group("player").plant()
        
    if Action_2.text == "Protect":
        get_tree().get_first_node_in_group("player").protect()
        
    if Action_2.text == "Eat":
        get_tree().get_first_node_in_group("crop").eat()
    
    Action_2.disabled = true
    check_actions()

# Handles pause/settings menu
func _on_settings_button_pressed():
    # Open menu
    $in_game_ui/PauseMenuContainer.show()

# Hides the pause menu
func _on_cancel_button_pressed():
    $in_game_ui/PauseMenuContainer.hide()

# Handles quitting the game
func _on_quit_button_pressed():
    get_tree().quit()

# Displays instructions on how to play
func _on_help_button_pressed():
    intruction_flag = true
    $in_game_ui/InstructionContainer.show()
    $in_game_ui/Tutorial.show()
    $in_game_ui/PauseMenuContainer.hide()


func _on_mute_button_pressed():
    var bus_index = AudioServer.get_bus_index("Master")
    AudioServer.set_bus_mute(bus_index, true)
