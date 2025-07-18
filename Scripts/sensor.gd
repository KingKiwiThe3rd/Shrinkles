extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if not body.has_method("get_form") or not body.has_method("get_player_velocity"):
		return
	
	# Check that the player is jumping into the block
	if body.get_player_velocity().y < 0 and body.get_form() == body.Form.LARGE:
		print("Breaking block from below!")
		get_parent().break_block()  # Calls break_block() on StaticBody2D parent
