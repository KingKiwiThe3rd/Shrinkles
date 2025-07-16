extends Area2D

@export var required_form: String = "LARGE"  # only "LARGE" can break it

func _on_body_entered(body):
	if not body.is_in_group("player"):
		return

	# Check if collision came from below
	var player = body
	var block_top = global_position.y
	var player_head = player.global_position.y + player.shape_owner_get_shape(0, 0).get_rect().position.y

	if player.velocity.y < 0 and player_head < block_top:
		# Check form
		if player.current_form == player.Form.LARGE:
			queue_free()  # destroy block
			# Optional: play sound or spawn particles
