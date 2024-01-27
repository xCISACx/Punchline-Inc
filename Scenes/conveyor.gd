extends Node3D

var speed = 2
var direction = Vector3.ZERO
var target : Marker3D

# Called when the node enters the scene tree for the first time.
func _ready():
	target = $Target

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _physics_process(_delta):
	pass

func _on_area_3d_body_entered(body):
	#body.moving = true
	if !body.current_conveyor:
		body.current_conveyor = self
		body.moving = true
		body.movement_speed = speed
		#print("this should only run once")
	#body.target_point = target
	#body.direction = transform.basis.z
	print(body.name + ": " + str(body.current_conveyor))
	
	#if body.is_in_group("Movable"):
		#body.direction = ($Target.position - body.position).normalized()
	#
	#print(name + " body entered: " + body.name)
	#body.moving = true
	#body.movement_speed = speed
	#body.direction = transform.basis.z
	#body.move(transform.basis.z)


func _on_area_3d_body_exited(body):
	print(name + " body exited: " + body.name)
	#body.moving = false
	pass # Replace with function body.
