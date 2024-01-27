extends Area3D

signal picked_up(item)

func _on_DetectionArea_body_entered(body):
	if body.has_method("pick_up"):
		emit_signal("picked_up", body)
