##extends Area2D
##
##@onready var timer: Timer = $Timer
##var shrinky: Node = null
##var is_disabled = false  # New flag
##
##func _on_body_entered(body: Node2D) -> void:
	##if is_disabled:
		##return
	##var robots = get_tree().get_nodes_in_group("Hazards")
	##for robot in robots:
		##if robot.has_method("Kill"):
			##robot.smile()
	##if body.name == "Shrinky":
		##print("you died from killzone")
		##is_disabled = true
		##Engine.time_scale = 0.25
		##var collider = get_node_or_null("CollisionShape2D")
		##if collider == null:
			##collider = get_node_or_null("CollisionPolygon2D")
##
		##if collider:
			##collider.set_deferred("disabled", true)
##
##
##
		##timer.start()
##
##func _on_timer_timeout() -> void:
	##Engine.time_scale = 1.0
	##get_tree().reload_current_scene()
##
#extends Area2D
#
#@onready var timer: Timer = $Timer
#@onready var collider: Node = null
#var has_triggered := false
#var shrinky: CharacterBody2D = null
#
#func _on_body_entered(body: Node2D) -> void:
	#if has_triggered or body.name != "Shrinky":
		#return
	#
	#has_triggered = true
	#shrinky = body as CharacterBody2D
	#print("you died from killzone")
	#
	## Get and disable the collider so it doesn't trigger again
	#collider = get_node_or_null("CollisionShape2D")
	#if collider == null:
		#collider = get_node_or_null("CollisionPolygon2D")
	#
	#if collider:
		#collider.set_deferred("disabled", true)
	#
	## Make hazards smile (if you want to keep this feature)
	#var robots = get_tree().get_nodes_in_group("Hazards")
	#for robot in robots:
		#if robot.has_method("smile"):
			#robot.smile()
	#
	## Freeze time and stop player movement
	#Engine.time_scale = 0.25
	#if shrinky:
		#shrinky.velocity = Vector2.ZERO
		#shrinky.hide()
	#
	#timer.start()
#
#func _on_timer_timeout() -> void:
	#Engine.time_scale = 1.0
	#
	#if shrinky and is_instance_valid(shrinky):
		#shrinky.show()
		#shrinky.die_and_respawn()
	#
	## Reset the killzone for future use
	#has_triggered = false
	#if collider:
		#collider.set_deferred("disabled", false)
	#
	#shrinky = null
#
	#
extends Area2D

@onready var timer: Timer = $Timer
@onready var collider: Node = null
var has_triggered := false
var shrinky: CharacterBody2D = null

func _on_body_entered(body: Node2D) -> void:
	if has_triggered or body.name != "Shrinky":
		return
	
	has_triggered = true
	shrinky = body as CharacterBody2D
	print("you died from killzone")
	
	# Get and disable the collider so it doesn't trigger again
	collider = get_node_or_null("CollisionShape2D")
	if collider == null:
		collider = get_node_or_null("CollisionPolygon2D")
	
	if collider:
		collider.set_deferred("disabled", true)
	
	# Make hazards smile (if you want to keep this feature)
	var robots = get_tree().get_nodes_in_group("Hazards")
	for robot in robots:
		if robot.has_method("smile"):
			robot.smile()
	
	# Freeze time and stop player movement BUT KEEP VISIBLE
	Engine.time_scale = 0.25
	if shrinky:
		shrinky.velocity = Vector2.ZERO
		# Character stays visible during death timer
	
	timer.start()

func _on_timer_timeout() -> void:
	Engine.time_scale = 1.0
	
	if shrinky and is_instance_valid(shrinky):
		shrinky.die_and_respawn()
	
	# Reset the killzone for future use
	has_triggered = false
	if collider:
		collider.set_deferred("disabled", false)
	
	shrinky = null
