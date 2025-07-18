extends StaticBody2D

@export var required_form: int = 3  # LARGE form

func _ready():
	add_to_group("Breakable")

func _on_sensor_body_entered(body: Node2D) -> void:
	if not body.has_method("get_form") or not body.has_method("get_player_velocity"):
		return

	if body.get_player_velocity().y < 0 and body.get_form() == required_form:
		break_block()


func break_block():
	queue_free()  # This destroys the entire block, not just a child
