extends RigidBody3D


var moving = false
var direction
var movement_speed = 2
var current_conveyor
var target_point
var target_marker

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if current_conveyor:
		if is_same_direction(direction, Vector3.ZERO):
				direction = current_conveyor.direction
	
	if target_marker:
		var target_marker_owner = target_marker.get_owner()
		#print(
			#"moving: " + str(moving) +
			#', direction: ' + str(direction) +
			#', movement_speed: ' + str(movement_speed) +
			#', current_conveyor: ' + str(current_conveyor) +
			#', target_point: ' + str(target_point) +
			#', target_marker: ' + str(target_marker_owner) +
			#'\n-------------------------------------------------'
		#)
	pass
	
func _physics_process(delta):
	if current_conveyor && moving:
		move_towards_target(delta)
		
func move_towards_target(delta):
	target_point = current_conveyor.target.global_position
	target_marker = current_conveyor.target

	direction = (target_point - global_position).normalized()
	direction.y = 0

	var motion = direction * movement_speed * delta
	move_and_collide(motion)

	if global_position.distance_squared_to(target_point) < 0.1:
		
		for area in $Area3D.get_overlapping_areas():
			if area.is_in_group("Conveyor Area"):
				current_conveyor = area.get_owner()
		
		print("change direction?")
		print("current conveyor: " + str(current_conveyor))

		if !is_same_direction(current_conveyor.direction, direction):
			print("change direction")
			change_direction()
		else:
			print("same direction")
			moving = true
			
func is_same_direction(a: Vector3, b: Vector3) -> bool:
	# Compare vectors using a threshold (epsilon)
	var dot_product = a.normalized().dot(b.normalized())
	var magnitude_product = a.length() * b.length()
	return abs(dot_product - magnitude_product) < 0.001

func change_direction():
	
	for area in $Area3D.get_overlapping_areas():
		if area.is_in_group("Conveyor Area"):
			current_conveyor = area.get_owner()
			target_point = current_conveyor.target.global_position
			target_marker = current_conveyor.target
			break
			
	moving = true

	var target_marker_owner = target_marker.get_owner()
	print("Changed direction to: " + str(current_conveyor) + ", target_marker_owner: " + str(target_marker_owner))
