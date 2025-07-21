# TimerManager.gd
extends Node

var elapsed_time = 0.0
var is_running = true

func _process(delta):
	if is_running:
		elapsed_time += delta

func reset():
	elapsed_time = 0.0

func get_formatted_time() -> String:
	var minutes = int(elapsed_time / 60)
	var seconds = int(elapsed_time) % 60
	return "%02d:%02d" % [minutes, seconds]
