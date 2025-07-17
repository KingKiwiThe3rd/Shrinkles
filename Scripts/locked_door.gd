extends StaticBody2D

@export var key_required := true

func _on_KeyCheck_body_entered(body):
	if body.is_in_group("player"):
		# Check if key is nearby
		for child in get_tree().get_nodes_in_group("keycards"):
			if child.picked_up and child.player_ref == body:
				open_door()
				break

func open_door():
	$CollisionShape2D.disabled = true
	$Sprite2D.visible = false  # or play open animation
	queue_free()  # or disable collision and hide
