extends Node3D

@onready var marker_3d: Marker3D = %Marker3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_pressed("spin camera right"):
		marker_3d.rotation.y +=1
	if Input.is_action_pressed("spin camera left"):
		marker_3d.rotation.y -=1
		
