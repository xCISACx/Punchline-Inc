extends Node3D

@export var text_input : Node3D
@export var player_list : Array[CharacterBody3D]
@onready var player: CharacterBody3D = $Level1/Player



func _ready():
	pass 


func _process(delta):
	if (player_list.size() > 0):
		if (player_list[0].collected_words.size() >= text_input.required_words
		and player_list[1].collected_words.size() >= text_input.required_words 
		and player_list[2].collected_words.size() >= text_input.required_words
		and player_list[3].collected_words.size() >= text_input.required_words):
			print("show")
			if !text_input.initialised:
				text_input.initialised = true
				text_input.initialise()
				$TextInput/Control.show()
	pass

func _on_redbox_body_entered(body: Node3D) -> void:
	if player_list[0].collected_words.size() < 5 and body.owner_id == 0: 
		player_list[0].collected_words.append(body.word)
		player_list[0].picked_object = null
		player_list[0].get_node("WordLabel").text = ""
		body.queue_free()
	print(player.collected_words)

func _on_bluebox_body_entered(body: Node3D) -> void:
	if player_list[1].collected_words.size() < 5 and body.owner_id == 1:
		player_list[1].collected_words.append(body.word)
		player_list[0].get_node("WordLabel").text = ""
		player_list[1].picked_object = null
		body.queue_free()

func _on_greenbox_body_entered(body: Node3D) -> void:
	if player_list[2].collected_words.size() < 5 and body.owner_id == 2:
		player_list[2].collected_words.append(body.word)
		player_list[0].get_node("WordLabel").text = ""
		player_list[2].picked_object = null
		body.queue_free()

func _on_yellowbox_body_entered(body: Node3D) -> void:
	if player_list[3].collected_words.size() < 5 and body.owner_id == 3:
		player_list[3].collected_words.append(body.word)
		player_list[0].get_node("WordLabel").text = ""
		player_list[3].picked_object = null
		body.queue_free()
