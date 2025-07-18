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
var stomp_enabled: bool = false

func try_stomp(player_global_position: Vector2) -> void:
	if not stomp_enabled:
		return

	stomp_area.global_position = player_global_position
	await get_tree().process_frame

	for area in stomp_area.get_overlapping_areas():
		if area.is_in_group("Breakable"):
			if area.has_method("break_block"):
				area.break_block()  # Assumes area *is* the StaticBody2D
			else:
				area.get_parent().break_block()  # Area2D's parent is the StaticBody2D
