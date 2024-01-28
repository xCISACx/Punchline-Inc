extends CharacterBody3D

const global_speed:= 4.5
@export var speed = 4.5
@export var fall_acceleration = 75
@export var jump_impulse = 20
@export var bounce_impulse = 10
var target_velocity = Vector3.ZERO
var pickedItem : Node = null

@onready var hand: Marker3D = %Hand
var picked_object
const global_pull_power: = 40
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
@onready var bigode_5: Node3D = %bellyguyRED
var controller_index = 0

@export var collected_words : Array[String]


func _ready():
	pass


func _physics_process(delta):
	bigode_5.animation_player.play()
	if velocity.y < 0:
		bigode_5.animation_player.set_assigned_animation("air")
	elif velocity.y == 0 and bigode_5.animation_player.get_assigned_animation() == "air":
		bigode_5.animation_player.set_assigned_animation(" IDLE")
	elif picked_object != null and bigode_5.animation_player.get_assigned_animation()\
	 != "Action" and bigode_5.animation_player.get_assigned_animation() != "PICKUP":
		bigode_5.animation_player.set_assigned_animation("WALK2")
	elif self.velocity == Vector3.ZERO and bigode_5.animation_player.get_assigned_animation()\
		== "WALK1":
		bigode_5.animation_player.set_assigned_animation(" IDLE")

	var direction = Vector3.ZERO

	if Input.is_action_pressed("move_right4"):
		direction.x += 1
		if picked_object == null and bigode_5.animation_player.get_assigned_animation()\
			!= "PICKUP" and bigode_5.animation_player.get_assigned_animation()\
				!= "jump" and is_on_floor():
			bigode_5.animation_player.set_assigned_animation("WALK1")

	if Input.is_action_pressed("move_left4"):
		direction.x -= 1
		if picked_object == null and bigode_5.animation_player.get_assigned_animation()\
			!= "PICKUP" and bigode_5.animation_player.get_assigned_animation() != "jump" \
				and is_on_floor():
			bigode_5.animation_player.set_assigned_animation("WALK1")

	if Input.is_action_pressed("move_back4"):
		direction.z += 1
		if picked_object == null and bigode_5.animation_player.get_assigned_animation()\
			!= "PICKUP" and bigode_5.animation_player.get_assigned_animation()!=\
				"jump" and is_on_floor():
			bigode_5.animation_player.set_assigned_animation("WALK1")

	if Input.is_action_pressed("move_forward4"):
		direction.z -= 1
		if picked_object == null and bigode_5.animation_player.get_assigned_animation()\
			!= "PICKUP" and bigode_5.animation_player.get_assigned_animation() !=\
				"jump" and is_on_floor():
			bigode_5.animation_player.set_assigned_animation("WALK1")

	if Input.is_action_just_pressed("pickup4"):
		for body in pick_up_area.get_overlapping_bodies():
			if body.is_in_group("Movable") and picked_object == null:
				var pickable_items = pick_up_area.get_overlapping_bodies()
				bigode_5.animation_player.set_assigned_animation("PICKUP")
				speed = 0
				await get_tree().create_timer(0.3).timeout
				picked_object = pickable_items[0]
				picked_object.set_collision_mask_value(4,false)
				#self.set_collision_mask_value(3,false)
				speed = global_speed
				anti_rotation_joint.set_node_b(picked_object.get_path())
				#picked_object.axis_lock_angular_x = true
				#picked_object.axis_lock_angular_y = true
				#picked_object.axis_lock_angular_z = true
				#if picked_object.moving != null:
					#picked_object.moving = false

				bigode_5.animation_player.set_assigned_animation("IDLE2")
				$WordLabel.text = picked_object.word
				print ("picked up")
			elif picked_object != null:
				
				drop_object()

	if Input.is_action_just_pressed("throw4"):
		if picked_object != null:
			var knockback = picked_object.global_position - self.global_position
			bigode_5.animation_player.set_assigned_animation("Action")
			#pull_power = 0
			#picked_object.position.y += 1
			await get_tree().create_timer(0.5).timeout
			pull_power = global_pull_power
			if picked_object is RigidBody3D:
				picked_object.apply_central_impulse(knockback*2.5)
			drop_object()

	if is_on_floor() and Input.is_action_just_pressed("jump4") and picked_object == null:
		bigode_5.animation_player.set_assigned_animation("jump")
		await get_tree().create_timer(0.3).timeout
		target_velocity.y = jump_impulse

	if direction != Vector3.ZERO and bigode_5.animation_player.get_assigned_animation()\
		!= "PICKUP":
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
				player.squash()
				player.speed = 0
				player.set_collision_mask_value(4,false)
				target_velocity.y = bounce_impulse
				
				break

	if picked_object != null:

		var a = picked_object.global_transform.origin
		var b = hand.global_transform.origin
		if picked_object is RigidBody3D:
			picked_object.set_linear_velocity((b-a)*pull_power)
		else:
			picked_object = null


func _unhandled_input(_event: InputEvent) -> void:
	pass


func drop_object() -> void:
	if picked_object != null:
		#picked_object.set_collision_mask_value(4,true)
		picked_object = null
		await get_tree().create_timer(0.5).timeout
		#self.set_collision_mask_value(3,true)
		anti_rotation_joint.set_node_b(anti_rotation_joint.get_path())
		bigode_5.animation_player.set_assigned_animation(" IDLE")
		$WordLabel.text = ""
		print("dropped object")
		
func generate_words():
	var text_input_scene = get_tree().root.get_node("Merged/TextInput")
	print(str(text_input_scene))
	if text_input_scene.word_list.size() != 0:
		for i in range(collected_words.size()):
			var random_index = randi_range(0, text_input_scene.word_list.size() - 1)
			var word = text_input_scene.word_list[random_index]
			if word.length() > 0:
				collected_words[i] = word
				text_input_scene.word_list.erase(word)
				text_input_scene.used_words_list.append(word)
			else:
				print("Empty word encountered!")
				i -= 1  # Retry with a different word index


func squash() -> void:
	speed = 4
	bigode_5.kill()
	print("squashed")
	await get_tree().create_timer(1).timeout
	speed = global_speed
