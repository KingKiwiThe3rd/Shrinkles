extends Area2D

@onready var timer_ui = get_node("../TimerLayer/TimerUI") #$TimerLayer/TimerUId
var global_game_data = { "final_time": 0.0 }


func _ready():
	# Debug: Check if timer_ui is valid
	if timer_ui == null:
		print("Error: timer_ui is null. Check node path $CanvasLayer/TimerUI")
	else:
		print("timer_ui found: ", timer_ui.name)


func _on_body_entered(body: Node2D) -> void:
	var final_time = 0.0
	if timer_ui != null and timer_ui.get("elapsed_time") != null:
		final_time = timer_ui.elapsed_time
		print("Passing elapsed_time: ", final_time)
	else:
		print("Error: Cannot access elapsed_time. Using fallback time 0.0")
	GlobalGameData.global_game_data.final_time = final_time
	get_tree().change_scene_to_file("res://scenes/final_cutscene.tscn")
