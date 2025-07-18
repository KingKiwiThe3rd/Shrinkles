extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var dash_manager = $Dash_Manager
@onready var stomp_manager = $Stomp_Manager

@export var sprite_frames: SpriteFrames
@export var tilemap: TileMap  # Reference to the TileMap with vent tiles
@export var camera: Camera2D  # Reference to the Camera2D node
@export var normal_zoom: Vector2 = Vector2(3.6, 3.6)  # Default zoom level
@export var vent_zoom: Vector2 = Vector2(7,7)  # Zoom level when in vent
@export var zoom_speed: float = 2.0  # Speed of zoom transition (units per second)

@onready var tile_map: TileMap = $"../TileMap"
var vent_source_id: int = 7  # Matches vent_source_id from vent_tilemap.gd
var target_zoom: Vector2  # Current target zoom level
var is_in_vent: bool = false

var is_preparing_jump = false
var is_landing = false
var jump_prepare_timer = 0.0
const JUMP_PREPARE_DURATION = 0.05
const LAND_DURATION = 0.2

var landing_timer = 0.0


var jumps_left = 1
const JUMP_AMOUNT = 1

@onready var switchFormParticles = get_node("switchFormParticles")

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

var is_on_ladder = false
var is_climbing = false


var keycard = null
var has_keycard: bool = false
var spawn_point: Vector2
@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	add_to_group("player")
	dash_manager.player = self
	# Only overwrite if checkpoint hasn't been saved yet
	if GameManager.checkpoint_position == Vector2.ZERO:
		GameManager.checkpoint_position = global_position

	spawn_point = GameManager.checkpoint_position
	global_position = spawn_point

	print("Shrinky spawned at: ", global_position)	
	camera=get_node("Camera2D")
	#tilemap=get_node("res://scenes/game/TileMap")


	var normal_frames := preload("res://Forms/normal_frames.tres")
	var large_frames := preload("res://Forms/large_frames.tres")
	var small_frames := preload("res://Forms/small_frames.tres")
	var smaller_frames := preload("res://Forms/smaller_frames.tres")

	normal_form.sprite_frames = normal_frames
	large_form.sprite_frames = large_frames
	small_form.sprite_frames = small_frames
	smaller_form.sprite_frames = smaller_frames

	
	smaller_form.scale = Vector2(1, 1)
	smaller_form.max_speed = 70
	smaller_form.jump_velocity = -80
	smaller_form.collision_size = Vector2(4, 4)
	smaller_form.can_dash = true
	smaller_form.animation_prefix = "smaller_"
	smaller_form.air_control = 300
	smaller_form.form_type = Form.SMALLER
	smaller_form.ladder_detector = Vector2(4,4)

	small_form.scale = Vector2(1, 1)
	small_form.max_speed = 60.0
	small_form.jump_velocity = -220.0
	small_form.collision_size = Vector2(5, 8)
	#small_form.can_dash = false
	small_form.animation_prefix = "small_"
	small_form.air_control = 200
	small_form.form_type = Form.SMALL
	small_form.ladder_detector = Vector2(5,8)

	normal_form.scale = Vector2(1.0, 1.0)
	normal_form.max_speed = 90.0
	normal_form.jump_velocity = -160.0
	normal_form.collision_size = Vector2(10, 15.9)
	normal_form.can_dash = false
	normal_form.animation_prefix = "normal_"
	normal_form.air_control = 350
	normal_form.form_type = Form.NORMAL
	normal_form.ladder_detector = Vector2(10,15.9)


	large_form.scale = Vector2(1, 1)
	large_form.max_speed = 70.0
	large_form.jump_velocity = -140.0
	large_form.collision_size = Vector2(15, 30)
	large_form.can_dash = false
	large_form.animation_prefix = "large_"
	large_form.air_control = 600
	large_form.form_type = Form.LARGE
	large_form.ladder_detector = Vector2(15,30)
	large_form.can_stomp = true


	switch_form(normal_form)# start with normal form
	
	# Initialize camera zoom and warn if not set
	if camera and is_instance_valid(camera):
		camera.zoom = normal_zoom
		target_zoom = normal_zoom
		print("Camera initialized with zoom: ", normal_zoom)
	else:
		push_warning("Camera2D not assigned or invalid! Please assign a Camera2D node to the 'camera' property in the Inspector.")

	# Check and attempt to find TileMap if not assigned
	if not tilemap or not is_instance_valid(tilemap):
		push_warning("TileMap not assigned or invalid! Attempting to find a TileMap in the scene...")
		# Try to find a TileMap in the scene
		var root = get_tree().current_scene
		if root:
			for node in root.get_children():
				if node is TileMap:
					tilemap = node
					print("Found TileMap: ", tilemap.name)
					break
		if not tilemap or not is_instance_valid(tilemap):
			push_warning("No valid TileMap found in the scene! Please assign a TileMap node with vent tiles (source_id = 7) to the 'tilemap' property in the Inspector.")
	else:
		print("TileMap assigned: ", tilemap.name)


func switch_form(form_data: FormData) -> void:

	current_form = form_data.form_type  # <-- THIS FIXES THE ISSUE

	if not current_animation_prefix==form_data.animation_prefix:
		switchFormParticles.emitting=true

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
	if stomp_manager:
		stomp_manager.stomp_enabled = form_data.can_stomp
		print("it's stomping time")



func _physics_process(delta: float) -> void:
	# Horizontal movement input
	var input_direction = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	var target_speed = input_direction * MAX_SPEED
	# Start climbing manually if inside ladder and pressing UP
	# === LADDER LOGIC ===
	if is_on_ladder:
		velocity = Vector2.ZERO  # Full gravity cancel
		velocity.x = 0           # Prevent flying bug
		jumps_left = JUMP_AMOUNT
			# Movement
		if Input.is_action_just_pressed("Jump"):
			is_on_ladder = false
			is_climbing = false
		elif Input.is_action_just_pressed("Dash"):
			is_on_ladder = false
			is_climbing = false
			jumps_left = JUMP_AMOUNT
		elif Input.is_action_pressed("Up"):
			velocity.y = -MAX_SPEED
		elif Input.is_action_pressed("Down"):
			velocity.y = MAX_SPEED
		else:
			velocity.y = 0

		# Exit at top or ground
		var top_of_ladder = global_position.y < $CollisionShape2D.global_position.y - $CollisionShape2D.shape.extents.y
		var bottom_of_ladder = is_on_floor()
		if top_of_ladder or bottom_of_ladder:
			is_on_ladder = false
			is_climbing = false
			jumps_left = JUMP_AMOUNT

		# Exit if not overlapping any ladder
		var still_touching_ladder := false
		for area in area_2d.get_overlapping_areas():
			if area.is_in_group("Ladder"):
				still_touching_ladder = true
				break
		if not still_touching_ladder:
			is_on_ladder = false
			is_climbing = false
			

	# ENTER LADDER ONLY IF PRESSING UP AND TOUCHING IT
	elif Input.is_action_pressed("Up"):
		for area in area_2d.get_overlapping_areas():
			if area.is_in_group("Ladder"):
				is_on_ladder = true
				is_climbing = true
				break



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
		dash_manager.air_dashes_used = 0  #check
		dash_manager.extra_air_dash = false  # check
		# dash_manager.reset_dash()

	if Input.is_action_just_pressed("Jump"):
		if is_on_floor() or jumps_left > 0:
			is_preparing_jump = true
			jump_prepare_timer = JUMP_PREPARE_DURATION

	if Input.is_action_just_pressed("Dash") and dash_manager.dash_enabled:
		dash_manager.try_dash()
	elif Input.is_action_just_pressed("GroundPound") and stomp_manager.stomp_enabled:
		stomp_manager.try_stomp(global_position)
		print("STOMP")

	var direction := Input.get_axis("Left", "Right")
	if not dash_manager.is_dashing && not is_on_ladder:
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
		switchFormParticles.scale=Vector2(1,1)
		switch_form(small_form)
		print("Current form: ", get_form())
	elif Input.is_action_just_pressed("normal_form"):
		switchFormParticles.scale=Vector2(2,2)
		switch_form(normal_form)
		print("Current form: ", get_form())
	elif Input.is_action_just_pressed("large_form"):
		switchFormParticles.scale=Vector2(3,3)
		switch_form(large_form)
		print("Current form: ", get_form())
	elif Input.is_action_just_pressed("smaller_form"):
		switchFormParticles.scale=Vector2(1,1)
		switch_form(smaller_form)
		print("Current form: ", get_form())
		
		# Check if player is on a vent tile
	if tilemap and is_instance_valid(tilemap):
		# Adjust position to check tile at player's feet (based on collision shape)
		var offset = Vector2(0, $CollisionShape2D.shape.size.y / 2) if $CollisionShape2D.shape is RectangleShape2D else Vector2.ZERO
		var check_pos = global_position + offset
		var tile_pos = tilemap.local_to_map(tilemap.to_local(check_pos))
		var tile_data = tilemap.get_cell_tile_data(0, tile_pos)
		is_in_vent = tile_data and tilemap.get_cell_source_id(0, tile_pos) == vent_source_id
	
	# Set target zoom based on vent status
	if camera and is_instance_valid(camera):
		target_zoom = vent_zoom if is_in_vent else normal_zoom
		# Smoothly interpolate camera zoom
		if camera.zoom != target_zoom:
			var new_zoom = camera.zoom.lerp(target_zoom, delta * zoom_speed)
			camera.zoom = new_zoom
			print("Camera zoom updated to: ", camera.zoom, " (target: ", target_zoom, ")")
	
	if dash_manager.is_dashing:
		animated_sprite_2d.play("smaller_dash")
	#elif is_preparing_jump:
		# pass
	# elif is_landing:
		# animated_sprite_2d.play("fallingFollowThrough")
	elif is_on_floor():
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

func get_facing_direction() -> int:
	return -1 if animated_sprite_2d.flip_h else 1

func get_form():
	return current_form
func get_player_velocity():
	return velocity

func give_keycard(card):
	has_keycard = true
	keycard = card
	if keycard:
		keycard.global_position = global_position + Vector2(0, -20)
		keycard.show()  # in case it was hidden
		
func set_spawn_point(new_spawn_point: Vector2):
	print("Shrinky has gotten the checkpoint")
	spawn_point = new_spawn_point


func die_and_respawn():
	print(">> die_and_respawn called")
	global_position = spawn_point
	velocity = Vector2.ZERO
	show()  # If you ever hide Shrinky
	var collider = get_node_or_null("CollisionShape2D")
	if collider:
		collider.disabled = false
	print("Player respawned at: ", global_position)

	var areas = get_tree().get_nodes_in_group("room")
	for area in areas:
		if area is Area2D and area.has_method("check_player_inside"):
			area.check_player_inside()
