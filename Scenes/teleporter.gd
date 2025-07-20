extends Area2D

@export var target_position: Vector2  # Set teleport coordinates in inspector

func _on_body_entered(body):
	if body.name == "Shrinky":  # Replace "Shrinky" with your player’s node name
		teleport_player(body)

func teleport_player(player):
	var fade = Transition.fade_to_black()
	if fade == null:
		player.global_position = target_position
		return

	await fade.finished

	player.global_position = target_position

	await get_tree().create_timer(0.1).timeout

	var fade_back = Transition.fade_from_black()
	if fade_back != null:
		await fade_back.finished
