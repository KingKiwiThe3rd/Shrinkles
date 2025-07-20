extends StaticBody2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var collision_shape_2d_Scanner: CollisionShape2D = $Scanner/CollisionShape2D

func open_door():
	collision_shape_2d.set_deferred("disabled", true)
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
