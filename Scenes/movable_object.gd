extends RigidBody3D

var moving = false
var direction
var movement_speed = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	print(str(moving) + ', ' + str(direction) + ', ' + str(movement_speed))
	pass
	
func _physics_process(delta):
	if moving:
		move_and_collide(direction * movement_speed * delta)
