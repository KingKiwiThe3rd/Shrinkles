extends StaticBody2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var collision_shape_2d_Scanner: CollisionShape2D = $Scanner/CollisionShape2D

var is_open = false

func _ready():
	add_to_group("Resettable")

func reset():
	is_open = false
	$CollisionShape2D.disabled = false
	show()

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
#extends StaticBody2D
#
#@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
#@onready var collision_shape_2d_Scanner: CollisionShape2D = $Scanner/CollisionShape2D
#var is_open = false
#var original_position: Vector2
#
#func _ready():
	#add_to_group("Resettable")
	#original_position = global_position
#
#func reset():
	#print("Door reset called")
	#is_open = false
	#$CollisionShape2D.disabled = false
	#global_position = original_position
	#show()
#
#func open_door():
	#is_open = true
	#collision_shape_2d.set_deferred("disabled", true)
	#
	## Remove keycard from player
	#if get_tree().get_first_node_in_group("player") as CharacterBody2D:
		#var player = get_tree().get_first_node_in_group("player") as CharacterBody2D
		#if player.keycard:
			#player.keycard.queue_free()
			#player.keycard = null
			#player.has_keycard = false
	#
	## Hide instead of queue_free so it can be reset
	#hide()
#
#func _on_scanner_body_entered(body: Node2D) -> void:
	#print("Scanner triggered")
	#if body is CharacterBody2D and not is_open:
		#var player = body as CharacterBody2D
		#if player.has_keycard:
			#open_door()
