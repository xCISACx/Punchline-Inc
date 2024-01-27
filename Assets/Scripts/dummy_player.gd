extends Node3D

var collected_words : Array[String]

# Called when the node enters the scene tree for the first time.
func _ready():
	collected_words.resize(5)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#generate_words()

func generate_words():
	if $"..".word_list.size() != 0:
		for i in range(collected_words.size()):
			var random_index = randi_range(0, $"..".word_list.size() - 1)
			var word = $"..".word_list[random_index]
			word = word.strip_edges()  # Assign the stripped word back to the variable
			if word.length() > 0:
				print(word)
				collected_words[i] = word
				$"..".word_list.erase(word)
				$"..".used_words_list.append(word)
			else:
				i -= 1  # Retry with a different word index
