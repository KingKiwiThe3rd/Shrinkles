extends Area2D

var picked_up := false
var player_ref: CharacterBody2D = null


func _on_body_entered(body):
	if body.is_in_group("player") and not picked_up:
		picked_up = true
		player_ref = body
		self.collision_layer = 0
		self.collision_mask = 0
		$CollisionShape2D.disabled = true
		z_index = 100  # make sure it's on top

func _process(delta):
	if picked_up and player_ref:
		global_position = player_ref.global_position + Vector2(0, -20)  # hover above player
