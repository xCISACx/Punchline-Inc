extends Node3D

@export var text_input : Node3D
@export var player_list : Array[CharacterBody3D]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (player_list.size() > 0):
		if (player_list[0].collected_words.size() == 5 
		and player_list[1].collected_words.size() == 5 
		and player_list[2].collected_words.size() == 5 
		and player_list[3].collected_words.size() == 5):
			print("show")
			$TextInput/Control.show()
	pass

func _on_redbox_body_entered(body: Node3D) -> void:
	if player_list.size() < 5: 
		player_list[0].collected_words.append(body.word)
		print("red kobe")

func _on_bluebox_body_entered(body: Node3D) -> void:
	if player_list.size() < 5:
		player_list[1].collected_words.append(body.word)
		print("blue kobe")

func _on_greenbox_body_entered(body: Node3D) -> void:
	if player_list.size() < 5:
		player_list[2].collected_words.append(body.word)
		print("green kobe")

func _on_yellowbox_body_entered(body: Node3D) -> void:
	if player_list.size() < 5:
		player_list[3].collected_words.append(body.word)
		print("yellow kobe")
