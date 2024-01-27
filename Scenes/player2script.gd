extends CharacterBody3D


@export var speed = 7
@export var fall_acceleration = 75
@export var jump_impulse = 20
@export var bounce_impulse = 10
var target_velocity = Vector3.ZERO
var pickedItem : Node = null

@onready var hand: Marker3D = %Hand
var picked_object
@export var pull_power := 40
@export var rotation_power := 0.05
@onready var anti_rotation_joint: Generic6DOFJoint3D = %AntiRotationJoint
@onready var interaction_1: RayCast3D = %Interaction1
@onready var interaction_2: RayCast3D = %Interaction2
@onready var interaction_3: RayCast3D = %Interaction3
@onready var interaction_4: RayCast3D = %Interaction4
@onready var interaction_5: RayCast3D = %Interaction5
@onready var interaction_6: RayCast3D = %Interaction6
@onready var pick_up_area: Area3D = %PickUpArea




func _ready():
	pass

func _physics_process(delta):
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_just_pressed("pickup"):
		for body in pick_up_area.get_overlapping_bodies():
			if body.is_in_group("Movable") and picked_object == null:
				var pickable_items = pick_up_area.get_overlapping_bodies()
				picked_object = pickable_items[0]
				anti_rotation_joint.set_node_b(picked_object.get_path())
				print ("picked up")
			elif picked_object != null:
				drop_object()
				#print("failed")
	if Input.is_action_just_pressed("throw"):
		if picked_object != null:
			var knockback = picked_object.position - self.position
			picked_object.rotation = Vector3(90,0,0)
			picked_object.apply_central_impulse(knockback*0.5)
			drop_object()

	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse


	if direction != Vector3.ZERO:
		direction = direction.normalized()
		$Pivot.basis = Basis.looking_at(direction)

	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	velocity = target_velocity
	move_and_slide()

	for index in range(get_slide_collision_count()):
		
		var collision = get_slide_collision(index)

	
		if collision.get_collider() == null:
			continue

		if collision.get_collider().is_in_group("player"):
			var player = collision.get_collider()
			# we check that we are hitting it from above.
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				# If so, we squash it and bounce.
				#player.squash()
				target_velocity.y = bounce_impulse
				# Prevent further duplicate calls.
				break

	if picked_object != null:
		var a = picked_object.global_transform.origin
		var b = hand.global_transform.origin
		picked_object.set_linear_velocity((b-a)*pull_power)
		

func _unhandled_input(_event: InputEvent) -> void:
	pass




#func pick_object() -> void:
	#var collider1 = interaction_1.get_collider()
	#var collider2 = interaction_2.get_collider()
	#var collider3 = interaction_3.get_collider()
	#var collider4 = interaction_4.get_collider()
	#var collider5 = interaction_5.get_collider()
	#var collider6 = interaction_6.get_collider()
	#
	#
	#if collider1 != null and collider1 is RigidBody3D:
		#picked_object = collider1
		#anti_rotation_joint.set_node_b(picked_object.get_path())
	#elif collider2 != null and collider2 is RigidBody3D:
		#picked_object = collider2
		#anti_rotation_joint.set_node_b(picked_object.get_path())
	#elif collider3 != null and collider3 is RigidBody3D:
		#picked_object = collider3
		#anti_rotation_joint.set_node_b(picked_object.get_path())
	#elif collider4 != null and collider4 is RigidBody3D:
		#picked_object = collider4
		#anti_rotation_joint.set_node_b(picked_object.get_path())
	#elif collider5 != null and collider5 is RigidBody3D:
		#picked_object = collider5
		#anti_rotation_joint.set_node_b(picked_object.get_path())
	#elif collider5 != null and collider5 is RigidBody3D:
		#picked_object = collider5
		#anti_rotation_joint.set_node_b(picked_object.get_path())
	#elif collider6 != null and collider6 is RigidBody3D:
		#picked_object = collider6
		#anti_rotation_joint.set_node_b(picked_object.get_path())

func drop_object() -> void:
	if picked_object != null:
		picked_object = null
		anti_rotation_joint.set_node_b(anti_rotation_joint.get_path())
		print("dropped object")


#func _on_area_3d_body_entered(body: Node3D) -> void:
	##if body is RigidBody3D:
	#picked_object = body
	#anti_rotation_joint.set_node_b(picked_object.get_path())
