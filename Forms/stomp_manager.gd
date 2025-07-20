#extends Node

#@onready var stomp_area: Area2D = $StompArea
#var stomp_enabled: bool = false
#
#func try_stomp(player_global_position: Vector2) -> void:
	#if not stomp_enabled:
		#return
#
	## Move the stomp area to player location
	#stomp_area.global_position = player_global_position
#
	## Process collisions manually
	#var overlapping = stomp_area.get_overlapping_areas()
	#for area in overlapping:
		#if area.is_in_group("Breakable"):
			#area.queue_free()

extends Node

@onready var stomp_area: Area2D = $StompArea
@onready var stomp_timer = $StompTimer
@onready var stomp_p = $StompParticles
var stomp_enabled: bool = false
var is_stomping: bool=false


func _ready():
	stomp_timer.timeout.connect(_on_timer_timeout)

func try_stomp(player_global_position: Vector2) -> void:
	if not stomp_enabled:
		return
	
	is_stomping=true
	stomp_timer.start()
	print("started stomping")
	stomp_area.global_position = player_global_position
	await get_tree().process_frame

	for area in stomp_area.get_overlapping_areas():
		if area.is_in_group("Breakable"):
			if area.has_method("break_block"):
				area.break_block()  # Assumes area *is* the StaticBody2D
			else:
				area.get_parent().break_block()  # Area2D's parent is the StaticBody2D
	
func _on_timer_timeout():
	is_stomping=false
	print("stopped stomping")
	stomp_p.emitting=true
	get_node("/root/game/Shrinky/ScreenShake").start_shake(15, 8)
