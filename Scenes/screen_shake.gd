extends Node2D


var shake_amount = 0.0
var shake_decay = 5.0
var max_shake = 10.0

func _process(delta):
	if shake_amount > 0:
		# Random offset inside a circle scaled by shake_amount
		position = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * shake_amount
		shake_amount = max(shake_amount - shake_decay * delta, 0)
	else:
		position = Vector2.ZERO

func start_shake(amount: float, decay: float = 5.0):
	shake_amount = clamp(amount, 0, max_shake)
	shake_decay = decay
