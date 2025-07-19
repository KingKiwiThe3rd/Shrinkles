extends Node2D

const SPEED =70
# Called when the node enters the scene tree for the first time.
var direction = -1

@onready var ray_cast_right: RayCast2D = $RayCast_Right
@onready var ray_cast_left: RayCast2D = $RayCast_Left
@onready var ray_cast_left_wall: RayCast2D = $RayCast_Left_wall
@onready var ray_cast_right_wall: RayCast2D = $RayCast_Right_wall

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _on_kill_zone_body_entered(body):
	if body.name == "Shrinky":
		print("hehehe")
		$AnimatedSprite2D.play("Kill")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if not ray_cast_right.is_colliding():
		direction =-1
		animated_sprite_2d.flip_h= false
		
	if not ray_cast_left.is_colliding():
		animated_sprite_2d.flip_h= true
		direction =1
		
	if  ray_cast_right_wall.is_colliding():
		direction =-1
		animated_sprite_2d.flip_h= false
		
	if ray_cast_left_wall.is_colliding():
		direction =1
		animated_sprite_2d.flip_h= true
		
	position.x += direction *SPEED *delta
