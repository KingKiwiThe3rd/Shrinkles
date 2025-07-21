extends Area2D

var picked_up := false
var player_ref: CharacterBody2D = null
var original_position

func _ready():
	add_to_group("Resettable")
	original_position = global_position

func reset():
	global_position = original_position
	show()

func _on_body_entered(body):
	if body is CharacterBody2D and not picked_up:
		picked_up = true
		player_ref = body
		$AudioStreamPlayer2D.play()
		player_ref.give_keycard(self)  # ← THIS is what was missing
		self.collision_layer = 0
		self.collision_mask = 0
		$CollisionShape2D.set_deferred("disabled", true)
		z_index = 100

func _process(delta):
	if picked_up and player_ref:
		global_position = player_ref.global_position + Vector2(0, -20)  # hover above player
#extends Area2D
#
#var picked_up := false
#var player_ref: CharacterBody2D = null
#var original_position: Vector2
#
#func _ready():
	#add_to_group("Resettable")
	#original_position = global_position
#
#func reset():
	#print("Keycard reset called")
	#picked_up = false
	#player_ref = null
	#global_position = original_position
	#show()
	#z_index = 0
	#collision_layer = 1  # Reset to original collision layer
	#collision_mask = 1   # Reset to original collision mask
	#$CollisionShape2D.disabled = false
#
#func _on_body_entered(body):
	#if body is CharacterBody2D and not picked_up:
		#picked_up = true
		#player_ref = body
		#$AudioStreamPlayer2D.play()
		#player_ref.give_keycard(self)
		#self.collision_layer = 0
		#self.collision_mask = 0
		#$CollisionShape2D.set_deferred("disabled", true)
		#z_index = 100
#
#func _process(delta):
	#if picked_up and player_ref:
		#global_position = player_ref.global_position + Vector2(0, -20)
