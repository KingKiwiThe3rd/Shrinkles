extends Area2D

@onready var timer_ui = get_node("res://scenes/game/TimerLayer/TimerUI") #$TimerLayer/TimerUId
var global_game_data = { "final_time": 0.0 }


func _ready():
	# Debug: Check if timer_ui is valid
	if timer_ui == null:
		print("Error: timer_ui is null. Check node path $CanvasLayer/TimerUI")
	else:
		print("timer_ui found: ", timer_ui.name)


func _on_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
	if timer_ui == null:
		print("Error: timer_ui is null during trigger_cutscene")
		global_game_data.final_time = 0.0  # Fallback to avoid crash
	else:
		get_node("/root").set("global_game_data", { "final_time": timer_ui.elapsed_time})
	# Transition to FinalCutscene
	get_tree().change_scene_to_file("res://scenes/final_cutscene.tscn")
