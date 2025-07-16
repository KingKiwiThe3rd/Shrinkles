extends StaticBody2D

@export var required_form: int = 3  # assumes 3 = LARGE

func _ready():
	pass

func _on_body_entered(body):
	print("hit by", body.name)

	if not body.has_method("get_form") or not body.has_method("get_player_velocity"):
		return

	var player = body
	var block_top = global_position.y
	var player_head = player.global_position.y + player.shape_owner_get_shape(0, 0).get_rect().position.y

	if player.get_velocity().y < 0 and player_head < block_top:
		if player.get_form() == player.Form.LARGE:
			queue_free()

func _on_Sensor_body_entered(body):
	pass


func _on_sensor_body_entered(body: Node2D) -> void:
	print("Sensor triggered by:", body.name)
	if not body.has_method("get_form") or not body.has_method("get_player_velocity"):
		return

	# Only break if player is jumping up into block
	if body.get_player_velocity().y < 0 and body.get_form() == required_form:
		queue_free()
