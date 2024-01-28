extends Node3D

@export var spawnable : PackedScene

func _ready() -> void:
	#spawn()
	pass

func spawn():
	var spawned_scene = spawnable.instantiate()
	add_child(spawned_scene)
	spawned_scene.global_position = self.global_position
	generate_word(spawned_scene)
	print(spawned_scene.word)

func _on_timer_timeout() -> void:
	spawn()
	
func generate_word(box):
	var text_input = get_owner().get_owner().text_input
	print("spawner: " + str(text_input))
	if text_input.word_list.size() != 0:
		var random_index = randi_range(0, text_input.word_list.size() - 1)
		var random_word = text_input.word_list[random_index]
		if random_word.length() > 0:
			print(random_word)
			box.word = random_word
			box.label.text = random_word
			print(box)
			text_input.word_list.erase(random_word)
			text_input.used_words_list.append(random_word)
		pass
