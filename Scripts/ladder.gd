extends Area2D

func _on_body_entered(body):
	if body.name == "Shrinky" and Input.is_action_pressed("Up"):
		print("on the ladder")
		body.is_on_ladder = true
		body.is_climbing = true

#func _on_body_exited(body):
	#if body.name == "Shrinky":
		#print("name is Shrinky")
		#await get_tree().process_frame
		#var still_touching = false
		#for area in get_overlapping_areas():
			#if area.is_in_group("Ladder"):
				#print("if area in group Ladder")
				#still_touching = true
				#break
		#if not still_touching:
			#print("not still touching")
			#body.is_on_ladder = false
			#body.is_climbing = false
