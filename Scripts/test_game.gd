extends Node2D

var turn_counter = 1

var action_array = ["Plant", "Plant", "Plant", "Plant", "Protect", 
"Protect", "Protect", "Protect", "Eat", "Eat"]

var action_1_used = false
var action_2_used = false
var action_3_used = false

signal plant
signal protect
signal eat

@export var Action_1:Button
@export var Action_2:Button
@export var Action_3:Button

# Called when the node enters the scene tree for the first time.
func _ready():
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
	# TODO: Trigger farmer actions
	# Call new turn
	new_turn()

func _on_action_1_pressed():
	print(Action_1.text)
	action_1_used = true
	if Action_1.text == "Plant":
		plant.emit()
		
	if Action_1.text == "Protect":
		# sent to player?
		pass
	if Action_1.text == "Eat":
		# sent to crop?
		pass

func _on_action_2_pressed():
	print(Action_2.text)
	action_2_used = true
	if Action_2.text == "Plant":
		pass
	if Action_2.text == "Protect":
		pass
	if Action_2.text == "Eat":
		pass

func _on_action_3_pressed():
	print(Action_3.text)
	action_3_used = true
	if Action_3.text == "Plant":
		pass
	if Action_3.text == "Protect":
		pass
	if Action_3.text == "Eat":
		pass

func _on_settings_button_pressed():
	# open menu
	# offer quit and main menu
	pass # Replace with function body.
