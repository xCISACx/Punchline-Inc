extends CharacterBody3D

@export var id : int
const global_speed:= 20
@export var speed = 20
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
#@onready var global_speed = speed
@onready var tes: Node3D = %bigode7
#var tween = get_tree().create_tween()
@onready var bigode_5: Node3D = %bigodechapel2
var controller_index = 0
@onready var dizzy: AudioStreamPlayer = %Dizzy

@export var collected_words : Array[String]
@onready var gimme_that: AudioStreamPlayer = %GimmeThat
@onready var jump_smash: AudioStreamPlayer = %JumpSmash


func _ready():
	pass


func _physics_process(delta):
	if position.y < 0.9:
		self.position = Vector3(2,2,2)
	bigode_5.animation_player.play()
	if velocity.y < 0:
		bigode_5.animation_player.set_assigned_animation("air")
	elif velocity.y == 0 and bigode_5.animation_player.get_assigned_animation() == "air":
		bigode_5.animation_player.set_assigned_animation("idle")
	elif picked_object != null and bigode_5.animation_player.get_assigned_animation()\
	 != "drop" and bigode_5.animation_player.get_assigned_animation() != "pickup":
		bigode_5.animation_player.set_assigned_animation("walk2")
	elif self.velocity == Vector3.ZERO and bigode_5.animation_player.get_assigned_animation()\
		== "walk":
		bigode_5.animation_player.set_assigned_animation("idle")

	var direction = Vector3.ZERO

	if Input.is_action_pressed("move_right"):
		direction.x += 1
		if picked_object == null and bigode_5.animation_player.get_assigned_animation()\
			!= "pickup" and bigode_5.animation_player.get_assigned_animation()\
				!= "jump1" and is_on_floor():
			bigode_5.animation_player.set_assigned_animation("walk")

	if Input.is_action_pressed("move_left"):
		direction.x -= 1
		if picked_object == null and bigode_5.animation_player.get_assigned_animation()\
			!= "pickup" and bigode_5.animation_player.get_assigned_animation() != "jump1" \
				and is_on_floor():
			bigode_5.animation_player.set_assigned_animation("walk")

	if Input.is_action_pressed("move_back"):
		direction.z += 1
		if picked_object == null and bigode_5.animation_player.get_assigned_animation()\
			!= "pickup" and bigode_5.animation_player.get_assigned_animation()!=\
				"jump1" and is_on_floor():
			bigode_5.animation_player.set_assigned_animation("walk")

	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
		if picked_object == null and bigode_5.animation_player.get_assigned_animation()\
			!= "pickup" and bigode_5.animation_player.get_assigned_animation() !=\
				"jump1" and is_on_floor():
			bigode_5.animation_player.set_assigned_animation("walk")

	if Input.is_action_just_pressed("pickup"):
		for body in pick_up_area.get_overlapping_bodies():
			if body.is_in_group("Movable") and picked_object == null:
				var pickable_items = pick_up_area.get_overlapping_bodies()
				bigode_5.animation_player.set_assigned_animation("pickup")
				speed = 0
				picked_object = pickable_items[0]
				#await get_tree().create_timer(1).timeout
				
				#picked_object.set_collision_mask_value(4,false)
				#self.set_collision_mask_value(3,false)
				speed = global_speed
				if picked_object: 
					anti_rotation_joint.set_node_b(picked_object.get_path())
				#picked_object.axis_lock_angular_x = true
				#picked_object.axis_lock_angular_y = true
				#picked_object.axis_lock_angular_z = true
				if picked_object.moving != null:
					picked_object.moving = false

				bigode_5.animation_player.set_assigned_animation("idle2")
				$WordLabel.text = picked_object.word
				picked_object.owner_id = id
				print ("picked up")
				break
			elif picked_object != null:
				drop_object()
				break

	if Input.is_action_just_pressed("throw"):
		if picked_object != null:
			var knockback = picked_object.global_position - self.global_position
			bigode_5.animation_player.set_assigned_animation("drop")
			#pull_power = 0
			#picked_object.position.y += 1
			await get_tree().create_timer(0.7).timeout
			pull_power = global_pull_power
			picked_object.apply_central_impulse(knockback*2.5)
			picked_object.owner_id = -1
			drop_object()

	if is_on_floor() and Input.is_action_just_pressed("jump") and picked_object == null:
		bigode_5.animation_player.set_assigned_animation("jump1")
		await get_tree().create_timer(0.1).timeout
		target_velocity.y = jump_impulse

	if direction != Vector3.ZERO and bigode_5.animation_player.get_assigned_animation()\
		!= "pickup":
		direction = direction.normalized()
		$Pivot.basis = Basis.looking_at(direction)

	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	

	for index in range(get_slide_collision_count()):
		
		var collision = get_slide_collision(index)

		if collision.get_collider() == null:
			continue

		if collision.get_collider().is_in_group("Player"):
			var player = collision.get_collider()
			# we check that we are hitting it from above.
			if Vector3.UP.dot(collision.get_normal()) > 0.1:
				# If so, we squash it and bounce.
				if player.picked_object != null:
					gimme_that.play()
				else:
					jump_smash.play()
				player.squash()
				player.speed = 0
				player.picked_object = null
				#player.set_collision_mask_value(4,false)
				target_velocity.y = bounce_impulse
				
				break

	velocity = target_velocity	
	move_and_slide()

	if picked_object != null:

		var a = picked_object.global_transform.origin
		var b = hand.global_transform.origin
		if bigode_5.animation_player.get_assigned_animation() == "throw":
			picked_object.set_linear_velocity((b-a)*pull_power)
		else:
			picked_object.set_linear_velocity((b-a)*pull_power)


func _unhandled_input(_event: InputEvent) -> void:
	pass
	
func generate_words():
	var text_input_scene = get_tree().root.get_node("Merged/TextInput")
	#print(str(text_input_scene))
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


func drop_object() -> void:
	if picked_object != null:
		#picked_object.set_collision_mask_value(4,true)
		picked_object.owner_id = -1
		$WordLabel.text = ""
		picked_object = null
		await get_tree().create_timer(0.5).timeout
		#self.set_collision_mask_value(3,true)
		anti_rotation_joint.set_node_b(anti_rotation_joint.get_path())
		bigode_5.animation_player.set_assigned_animation("idle")
		
		print("dropped object")


func squash() -> void:
	speed = 0
	bigode_5.kill()
	print("squashed")
	dizzy.play()
	await get_tree().create_timer(1.5).timeout
	speed = global_speed
