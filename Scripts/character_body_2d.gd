extends CharacterBody2D

var is_preparing_jump = false
var is_landing = false
var jump_prepare_timer = 0.0
const JUMP_PREPARE_DURATION = 0.05
const LAND_DURATION = 0.2

var landing_timer = 0.0

var jumps_left = 2
const JUMP_AMOUNT = 2
const JUMP_VELOCITY = -120.0
const JUMP_CUT_MULTIPLIER = 0.3
const GRAVITY = 300.0
const MAX_FALL_SPEED = 700.0

const MAX_SPEED = 50.0
const ACCELERATION = 400.0
const DECELERATION = 500.0
const AIR_CONTROL = 200.0

func _physics_process(delta: float) -> void:
	# Horizontal movement input
	var input_direction = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	var target_speed = input_direction * MAX_SPEED
	
	if is_on_floor():
		if abs(target_speed) > 0.1:
			velocity.x = move_toward(velocity.x, target_speed, ACCELERATION * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)
	else:
		# Air control is weaker
		velocity.x = move_toward(velocity.x, target_speed, AIR_CONTROL * delta)

	# Jump logic
	if is_on_floor():
		jumps_left = JUMP_AMOUNT
		if is_landing:
			landing_timer -= delta
			if landing_timer <= 0.0:
				is_landing = false

	if Input.is_action_just_pressed("Jump"):
		if is_on_floor() or jumps_left > 0:
			is_preparing_jump = true
			jump_prepare_timer = JUMP_PREPARE_DURATION

	if is_preparing_jump:
		jump_prepare_timer -= delta
		if jump_prepare_timer <= 0.0:
			is_preparing_jump = false
			velocity.y = JUMP_VELOCITY
			jumps_left -= 1

	# Jump cut (short hop)
	if Input.is_action_just_released("Jump") and velocity.y < 0:
		velocity.y *= JUMP_CUT_MULTIPLIER

	# Gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		if velocity.y > MAX_FALL_SPEED:
			velocity.y = MAX_FALL_SPEED
	elif velocity.y > 0:
		# On ground, stop downward momentum
		velocity.y = 0

	# Landing detection
	if is_on_floor() and velocity.y >= 0 and not is_landing:
		is_landing = true
		landing_timer = LAND_DURATION

	move_and_slide()
