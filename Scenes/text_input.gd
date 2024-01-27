extends Node3D

var choices_made = false
@export var original_text : String
@export var current_text : String

@export var player_choices : Array[String] = ["", "", ""]
var all_player_keys = ["1", "2", "3", "4", "5", "Z", "X", "C", "V", "B", "Y", "U", "I", "O", "P"]

@export var text_edit : TextEdit
@export var submitted_text : Label
@export var main_joke_container : VBoxContainer
@export var joke_container : VBoxContainer
@export var card_container : HBoxContainer
@export var submission_container : VBoxContainer
@export var main_answer_card_container : VBoxContainer
@export var answer_card_container : HBoxContainer
@export var winning_player_label : Label
@export var winner_label : Label

var winner_id

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_text_edit_text_changed():
	original_text = text_edit.text
	current_text = text_edit.text
	
func _on_submit_button_pressed():
	if len(current_text) > 0 && current_text.contains("_"):
		text_edit.editable = false
		submitted_text.text = current_text
		joke_container.hide()
		submitted_text.get_parent().show()
		card_container.show()
		winning_player_label.show()

func word_button_pressed(button, text):
	submitted_text.text = original_text
	print(text)
	print(original_text)
	var new_text = submitted_text.text.replace("_", text)
	submitted_text.text = new_text
	print(new_text)
	print(submitted_text)
	winner_id = button.player_id
	winning_player_label.text = "Player " + str(button.player_id + 1) + " is going to win this round."
 
func _on_button_1_pressed():
	var answer_card_container_path = get_path_to(answer_card_container)
	var button = get_node(str(answer_card_container_path) + "/Button1/")
	var button_text = button.get_node("Label").text
	word_button_pressed(button, button_text)

func _on_button_2_pressed():
	var answer_card_container_path = get_path_to(answer_card_container)
	var button = get_node(str(answer_card_container_path) + "/Button2/")
	var button_text = button.get_node("Label").text
	word_button_pressed(button, button_text)

func _on_button_3_pressed():
	var answer_card_container_path = get_path_to(answer_card_container)
	var button = get_node(str(answer_card_container_path) + "/Button3/")
	var button_text = button.get_node("Label").text
	word_button_pressed(button, button_text)
	
var player_key_mapping := {
	0: ["1", "2", "3", "4", "5"],
	1: ["Z", "X", "C", "V", "B"],
	2: ["Y", "U", "I", "O", "P"]
}

# Dictionary to map keys to functions
var key_function_mapping := {
	"1": "player_choice_pressed, 0, 0",
	"2": "player_choice_pressed, 0, 1",
	"3": "player_choice_pressed, 0, 2",
	"4": "player_choice_pressed, 0, 3",
	"5": "player_choice_pressed, 0, 4",
	"Z": "player_choice_pressed, 1, 0",
	"X": "player_choice_pressed, 1, 1",
	"C": "player_choice_pressed, 1, 2",
	"V": "player_choice_pressed, 1, 3",
	"B": "player_choice_pressed, 1, 4",
	"Y": "player_choice_pressed, 2, 0",
	"U": "player_choice_pressed, 2, 1",
	"I": "player_choice_pressed, 2, 2",
	"O": "player_choice_pressed, 2, 3",
	"P": "player_choice_pressed, 2, 4",
}

func _input(event):
	if !choices_made:
		if event is InputEventKey:
			var pressed_key = char(event.unicode).to_upper()
			for player_id in player_key_mapping.keys():
				if pressed_key in player_key_mapping[player_id]:
					print("Player ID:", player_id)
					handle_player_input(player_id, pressed_key)
					break

func handle_player_input(player_id, key):
	call_stored_function(str(key_function_mapping[str(key)]))
		
func player_choice_pressed(player_id, choice_index):
	#print(choice_index)
	var node_path = "Control/MainJokeContainer/SubmissionContainer/CardContainer/ChoiceContainer" + str(player_id + 1) + "/ChoiceContainer" + "/ChoicePromptContainer" + str(choice_index + 1) + "/Button"
	#print("$Control/CardContainer/ChoiceContainer" + str(player_id + 1) + "/ChoiceContainer" + "/ChoicePromptContainer" + str(choice_index + 1) + "/Button")
	var choice = get_node(node_path)
	player_choices[player_id] = str(choice.text)
	if choice:
		#print(choice)
		print(choice.text)
		var answer_node_path = "Control/MainJokeContainer/AnswerCardMainContainer/AnswerCardContainer/Button" + str(player_id + 1) + "/Label"
		var current_player_answer = current_text.replace("_", choice.text)
		get_node(answer_node_path).text = choice.text
		print("choice text for player " + str(player_id + 1) + ": " + choice.text)
		if player_choices[0] and player_choices[1] and player_choices[2]:
			choices_made = true
			card_container.hide()
			main_answer_card_container.show()
	#var choice = get_node("$Control/CardContainer/ChoiceContainer" + str(player_id + 1)).get_children(choice_index)
	#print(choice.text)
	
# Function to parse and call the stored function with its arguments
func call_stored_function(entry):
	var parts = entry.split(",")
	var func_name = parts[0]
	var args = []
	for arg in parts:
		args.append(arg.to_int())
		
	#print(args)

	# Call the function with its arguments
	match func_name:
		"player_choice_pressed":
			print(str(args[1]) + ", " + str(args[2]))
			player_choice_pressed(args[1], args[2])
		# Add more functions as needed


func _on_pick_winner_button_pressed():
	main_joke_container.hide()
	winner_label.text = "PLAYER " + str(winner_id + 1) + " WINS!"
	winner_label.show()
