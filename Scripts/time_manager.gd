extends Node

var game_time := 0.0
var timer_running := false

func _process(delta):
	if timer_running:
		game_time += delta

func reset_timer():
	game_time = 0.0

func get_time() -> float:
	return game_time
