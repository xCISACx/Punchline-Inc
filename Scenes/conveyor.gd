extends Node3D

var speed = 2

@export var rigidbody : RigidBody3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(_delta):
	pass

func _on_area_3d_body_entered(body):
	#print("body entered")
	body.moving = true
	body.movement_speed = speed
	body.direction = transform.basis.z
	#body.move(transform.basis.z)


func _on_area_3d_body_exited(body):
	body.moving = false
	pass # Replace with function body.
