extends Node

@onready var button: Button = $Panel/TextureRect/Button
@onready var timer: Timer = %Timer
@onready var button_2: Button = %Button2



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#start_button_loop()
	pass

func start_button_loop() -> void:
	var button_tween := create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	button_tween.set_loops()
	
	button_tween.tween_property(button, "position:y", button.position.y -10, 0.2)
	button_tween.tween_property(button, "position:y", button.position.y, 0.2)
	
	button_tween.tween_interval(2)


func _on_button_pressed() -> void:
	$Panel/TextureRect/Button.get_node("AnimationPlayer").play("play_animation")
	timer.start()

func _on_button_2_pressed() -> void:
	button_2.get_node("AnimationPlayer").play("quit_animation")
	timer.start()

func _on_timer_timeout() -> void:
	print("load game")

