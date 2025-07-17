extends Node2D

const SPEED =25
# Called when the node enters the scene tree for the first time.
var direction = -1

@onready var ray_cast_right: RayCast2D = $RayCast_Right
@onready var ray_cast_left: RayCast2D = $RayCast_Left
@onready var ray_cast_left_wall: RayCast2D = $RayCast_Left_wall
@onready var ray_cast_right_wall: RayCast2D = $RayCast_Right_wall
@onready var ray_cast_right_celing: RayCast2D = $RayCast_Right_Celing
@onready var ray_cast_left_celing: RayCast2D = $RayCast_Left_Celing

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var kill_zone: Area2D = $Kill_zone


func _on_kill_zone_body_entered(body):
	if body.name == "Shrinky":
		print("hehehe")
		$AnimatedSprite2D.play("Kill")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Wall or ceiling collisions take priority
	if ray_cast_right_wall.is_colliding() or ray_cast_right_celing.is_colliding():
		direction = -1
		animated_sprite_2d.flip_h = false

	elif ray_cast_left_wall.is_colliding() or ray_cast_left_celing.is_colliding():
		direction = 1
		animated_sprite_2d.flip_h = true

	# Then check for floor detection loss
	elif not ray_cast_right.is_colliding():
		direction = -1
		animated_sprite_2d.flip_h = false

	elif not ray_cast_left.is_colliding():
		direction = 1
		animated_sprite_2d.flip_h = true

	# Move
	position.x += direction * SPEED * delta


func smile():
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("Kill")
