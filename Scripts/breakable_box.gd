extends StaticBody2D

var original_position
@export var required_form: int = 3  # LARGE form

func _ready():
	add_to_group("Breakable")
	add_to_group("Resettable")
	original_position = global_position

func reset():
	global_position = original_position
	show()
	$CollisionShape2D.disabled = false

func _on_sensor_body_entered(body: Node2D) -> void:
	if not body.has_method("get_form") or not body.has_method("get_player_velocity"):
		return

	if body.get_player_velocity().y < 0 and body.get_form() == required_form:
		break_block()


func break_block():
	queue_free()  # This destroys the entire block, not just a child
