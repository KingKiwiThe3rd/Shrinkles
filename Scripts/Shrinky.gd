extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var dash_manager = $Dash_Manager
@export var sprite_frames: SpriteFrames

var is_preparing_jump = false
var is_landing = false
var jump_prepare_timer = 0.0
const JUMP_PREPARE_DURATION = 0.05
const LAND_DURATION = 0.2

var landing_timer = 0.0

var jumps_left = 2
const JUMP_AMOUNT = 2
var JUMP_VELOCITY = -240.0
var JUMP_CUT_MULTIPLIER = 0.3
var GRAVITY = 300.0
var MAX_FALL_SPEED = 700.0

var MAX_SPEED = 100.0
var ACCELERATION = 300.0
var DECELERATION = 400.0
var AIR_CONTROL = 400.0
var accel = ACCELERATION if is_on_floor() else AIR_CONTROL

var image = Image.new()
var current_animation_prefix := "normal_"  # default


enum Form { SMALLER ,SMALL, NORMAL, LARGE }
var current_form: Form = Form.NORMAL

var smaller_form := FormData.new()
var small_form := FormData.new()
var normal_form := FormData.new()
var large_form := FormData.new()


func _ready() -> void:
	var normal_frames := preload("res://Forms/normal_frames.tres")
	var large_frames := preload("res://Forms/large_frames.tres")
	var small_frames := preload("res://Forms/small_frames.tres")
	var smaller_frames := preload("res://Forms/smaller_frames.tres")

	normal_form.sprite_frames = normal_frames
	large_form.sprite_frames = large_frames
	small_form.sprite_frames = small_frames
	smaller_form.sprite_frames = smaller_frames
	
	smaller_form.scale = Vector2(1.0, 1.0)
	smaller_form.max_speed = 80
	smaller_form.jump_velocity = -80
	smaller_form.collision_size = Vector2(2.5, 3.75)
	smaller_form.can_dash = true
	smaller_form.animation_prefix = "tiny_"
	smaller_form.air_control = 500

	small_form.scale = Vector2(1.0, 1.0)
	small_form.max_speed = 70.0
	small_form.jump_velocity = -300.0
	small_form.collision_size = Vector2(5, 7.5)
	#small_form.can_dash = false
	small_form.animation_prefix = "small_"
	small_form.air_control = 200

	normal_form.scale = Vector2(1.0, 1.0)
	normal_form.max_speed = 100.0
	normal_form.jump_velocity = -240.0
	normal_form.collision_size = Vector2(10, 15)
	normal_form.can_dash = false
	normal_form.animation_prefix = "normal_"
	normal_form.air_control = 350
	
	large_form.scale = Vector2(1.0, 1.0)
	large_form.max_speed = 60.0
	large_form.jump_velocity = -150.0
	large_form.collision_size = Vector2(15, 28)
	large_form.can_dash = false
	large_form.animation_prefix = "large_"
	normal_form.air_control = 400
	# Link this player to the dash manager
	dash_manager.player = self
	switch_form(normal_form)# start with normal form


func switch_form(form_data: FormData) -> void:
	scale = form_data.scale
	MAX_SPEED = form_data.max_speed
	JUMP_VELOCITY = form_data.jump_velocity
	# $AnimatedSprite2D.texture=form_data.texture
	$AnimatedSprite2D.play(form_data.animation_name)

	current_animation_prefix = form_data.animation_prefix
	$AnimatedSprite2D.sprite_frames = form_data.sprite_frames
	
		# Replace the shape to avoid modifying a shared resource
	var new_shape := RectangleShape2D.new()
	new_shape.size = form_data.collision_size
	$CollisionShape2D.shape = new_shape
	
	# Pass abilities to DashManager
	if dash_manager:
		dash_manager.dash_enabled = form_data.can_dash



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

	# Reset on floor
	if is_on_floor():
		dash_manager.air_dashes_used = 0
		dash_manager.extra_air_dash = false
		dash_manager.reset_dash()

	if Input.is_action_just_pressed("Jump"):
		if is_on_floor() or jumps_left > 0:
			is_preparing_jump = true
			jump_prepare_timer = JUMP_PREPARE_DURATION

	if Input.is_action_just_pressed("Dash") and dash_manager.dash_enabled:
		dash_manager.try_dash()
	
	var direction := Input.get_axis("Left", "Right")
	if not dash_manager.is_dashing:
		var current_accel = ACCELERATION if is_on_floor() else AIR_CONTROL
		velocity.x = move_toward(velocity.x, direction * MAX_SPEED, current_accel * delta)
		animated_sprite_2d.flip_h = direction < 0 if direction != 0 else animated_sprite_2d.flip_h
	
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

	if Input.is_action_just_pressed("small_form"):
		switch_form(small_form)
	elif Input.is_action_just_pressed("normal_form"):
		switch_form(normal_form)
	elif Input.is_action_just_pressed("large_form"):
		switch_form(large_form)
	elif Input.is_action_just_pressed("smaller_form"):
		switch_form(smaller_form)
	
	# if dash_manager.is_dashing:
		# animated_sprite_2d.play("dash")
	#elif is_preparing_jump:
		# pass
	# elif is_landing:
		# animated_sprite_2d.play("fallingFollowThrough")
	if is_on_floor():
		if direction == 0:
			animated_sprite_2d.play(current_animation_prefix +"idle")
		else:
			animated_sprite_2d.play(current_animation_prefix +"run")
	else:
		if velocity.y < 25:
			animated_sprite_2d.play(current_animation_prefix +"jump")
		# else:
			# animated_sprite_2d.play("falling")
	# update_animation()
	move_and_slide()
	
func update_animation():
	if not is_on_floor():
		$AnimatedSprite2D.play(current_animation_prefix + "jump")
	elif abs(velocity.x) > 5:
		$AnimatedSprite2D.play(current_animation_prefix + "run")
	else:
		$AnimatedSprite2D.play(current_animation_prefix + "idle")


func get_facing_direction() -> int:
	return -1 if animated_sprite_2d.flip_h else 1
