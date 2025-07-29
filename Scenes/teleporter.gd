extends Area2D

@export var target_position: Vector2  # Set teleport coordinates in inspector

func _on_body_entered(body):
	if body.name == "Shrinky":  # Replace "Shrinky" with your player’s node name
		teleport_player(body)

#func teleport_player(player):
	#var fade = Transition.fade_to_black()
	#if fade == null:
		#player.global_position = target_position
		#return
#
	#await get_tree().create_timer(2.5).timeout
	#
	#player.global_position = target_position
#
	#await get_tree().create_timer(1).timeout
#
	#
	#var fade_back = Transition.fade_from_black()
	#if fade_back == null:
		#print("⚠️ fade_from_black() failed in HTML5")
		#return
#
	#if fade_back != null:
		#print("no ⚠️ fade_from_black() should not failed in HTML5")
		##await fade_back.finished
		#await get_tree().create_timer(1.0).timeout
		
func teleport_player(player):
	var fade = Transition.fade_to_black()
	if fade == null:
		player.global_position = target_position
		return

	await get_tree().create_timer(2.5).timeout
	player.global_position = target_position

	await get_tree().create_timer(1).timeout  # Manual wait instead of fade_back.finished

	var fade_back = Transition.fade_from_black()
	# No await fade_back.finished due to HTML5 bug 
  
