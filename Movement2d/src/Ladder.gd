extends Area2D


func _on_Ladder_body_entered(body):
	if body.is_in_group("climber"):
		if body.climbing == false:
			body.climbing = true


func _on_Ladder_body_exited(body):
	if body.is_in_group("climber"):
		if body.climbing == true:
			body.climbing = false
