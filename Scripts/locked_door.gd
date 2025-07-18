extends StaticBody2D

func _on_KeyCheck_body_entered(body):
	if body.has_method("has_keycard") and body.has_keycard:
		open_door()

func open_door():
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite2D.visible = false
	if get_tree().get_first_node_in_group("player") as CharacterBody2D:
		var player = get_tree().get_first_node_in_group("player") as CharacterBody2D
		if player.keycard:
			player.keycard.queue_free()
			player.keycard = null
			player.has_keycard = false
	call_deferred("queue_free")  # optional: if you want to remove the door itself too


func _on_scanner_body_entered(body: Node2D) -> void:
	print ("yes")
	if body is CharacterBody2D:
		var player = body as CharacterBody2D
		if player.has_keycard:
			open_door()
