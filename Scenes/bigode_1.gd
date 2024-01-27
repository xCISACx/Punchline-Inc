extends Node3D
@onready var armature: Node3D = %Armature
@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready() -> void:
	#%Armature/Skeleton3D.physical_bones_start_simulation()
	%Armature/Skeleton3D.animate_physical_bones = false
	#animation_player.set_loops
