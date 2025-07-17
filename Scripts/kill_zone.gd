extends Area2D

@onready var timer: Timer = $Timer
var shrinky: Node = null
var is_disabled = false  # New flag

func _on_body_entered(body: Node2D) -> void:
	if is_disabled:
		return

	if body.name == "Shrinky":
		print("you died from killzone")
		is_disabled = true
		Engine.time_scale = 0.25
		$CollisionShape2D.set_deferred("disabled", true)
		timer.start()

func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	get_tree().reload_current_scene()



	
