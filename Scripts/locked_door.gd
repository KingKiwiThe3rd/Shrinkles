extends StaticBody2D

func open_door():
	$CollisionShape2D.set_deferred("disabled", true)
	#$AnimationPlayer.play("opened")
	if get_tree().get_first_node_in_group("player") as CharacterBody2D:
		var player = get_tree().get_first_node_in_group("player") as CharacterBody2D
		if player.keycard:
			player.keycard.queue_free()
			player.keycard = null
			player.has_keycard = false
	#await $AnimationPlayer.animation_finished
	call_deferred("queue_free")  # optional: if you want to remove the door itself too
#
#func open_door():
	#$CollisionShape2D.set_deferred("disabled", true)
	#var anim_player = $AnimationPlayer
	#anim_player.play("opened")
	#await anim_player.animation_finished
	#queue_free()  # only if you want it gone
func _on_scanner_body_entered(body: Node2D) -> void:
	print ("yes")
	if body is CharacterBody2D:
		var player = body as CharacterBody2D
		if player.has_keycard:
			open_door()
