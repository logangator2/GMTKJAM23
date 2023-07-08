extends Node2D

var turn_counter = 1

var intruction_flag : bool = true

var action_array = ["Plant", "Plant", "Plant", "Plant", "Protect", 
"Protect", "Protect", "Protect", "Eat", "Eat"]

var action_1_used = false
var action_2_used = false
var action_3_used = false

@export var map_scene: PackedScene

@export var Action_1:Button
@export var Action_2:Button
@export var Action_3:Button

# Called when the node enters the scene tree for the first time.
func _ready():
    var map = map_scene.instantiate()
    add_child(map)
    # Shuffle actions, make sure eat is not in first 'hand'
    action_array.shuffle()
    if turn_counter == 1 and (action_array[0] == "Eat"):
        action_array[0] = "Plant"
    if turn_counter == 1 and (action_array[1] == "Eat"):
        action_array[1] = "Plant"
    if turn_counter == 1 and (action_array[2] == "Eat"):
        action_array[2] = "Plant"
        
    # Create Button Names
    Action_1.text = action_array[0]
    Action_2.text = action_array[1]
    Action_3.text = action_array[2]

func _input(event):
    if (Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and intruction_flag:
        $in_game_ui/InstructionContainer.hide()
        intruction_flag = false
        
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if $in_game_ui/InstructionContainer/GameMusic.playing == false:
        $in_game_ui/InstructionContainer/GameMusic.play()

# Handle a new turn
func new_turn():
    print("Starting turn %d" % turn_counter)
    
    # Shuffle Actions
    action_array.shuffle()
    # NOTE: Error in logic since action button 1 will always be Eat after turn 3
    if turn_counter > 3 and (action_array[0] != "Eat" or action_array[1] != "Eat" or action_array[2] != "Eat"):
        action_array[0] = "Eat"
    
    # Reset Button Names
    Action_1.text = action_array[0]
    Action_2.text = action_array[1]
    Action_3.text = action_array[2]
    
    # Reset Button Uses
    action_1_used = false
    action_2_used = false
    action_3_used = false

# Handles when end turn button is pressed
func _on_end_turn_button_pressed():
    # Increment turn counter
    print("Turn Ended")
    turn_counter += 1
    # Trigger farmer actions
    get_child(1, true).get_child(6, true).farmer_start()
    # Call new turn
    new_turn()

func _on_action_1_pressed():
    print(Action_1.text)
    action_1_used = true
    if Action_1.text == "Plant":
        get_child(1, true).get_child(1, true).plant()
        
    if Action_1.text == "Protect":
        get_child(1, true).get_child(1, true).protect()
        
    if Action_1.text == "Eat":
        get_child(1, true).get_child(1, true).eat()

func _on_action_2_pressed():
    print(Action_2.text)
    action_2_used = true
    if Action_2.text == "Plant":
        get_child(1, true).get_child(1, true).plant()
        
    if Action_2.text == "Protect":
        get_child(1,true).get_child(1,true).protect()
        
    if Action_2.text == "Eat":
        get_child(1, true).get_child(1, true).eat()
        

func _on_action_3_pressed():
    print(Action_3.text)
    action_3_used = true
    if Action_3.text == "Plant":
        get_child(1, true).get_child(1, true).plant()
        
    if Action_3.text == "Protect":
        get_child(1,true).get_child(1,true).protect()
        
    if Action_3.text == "Eat":
        get_child(1, true).get_child(1, true).eat()

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
    $in_game_ui/PauseMenuContainer.hide()
