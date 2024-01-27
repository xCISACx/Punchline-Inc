extends Node3D

@export var spawnable : PackedScene

func _ready() -> void:
	spawn()

func spawn():
	var spawned_scene = spawnable.instantiate()
	add_child(spawned_scene)
	spawned_scene.position = self.global_position


func _on_timer_timeout() -> void:
	spawn()
	print("a")
