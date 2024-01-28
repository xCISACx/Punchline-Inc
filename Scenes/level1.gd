extends Node3D

@onready var label_3d: Label3D = %Label3D
@onready var text: Array[String] = ["NT nerd"]

func _on_redbox_body_entered(_body: Node3D) -> void:
	text.push_front("Nice ****")
	print("red kobe")


func _on_bluebox_body_entered(_body: Node3D) -> void:
	print("blue kobe")


func _on_greenbox_body_entered(_body: Node3D) -> void:
	print("green kobe")


func _on_yellowbox_body_entered(_body: Node3D) -> void:
	print("yellow kobe")


func _process(_delta: float) -> void:
	label_3d.text = text[0]
