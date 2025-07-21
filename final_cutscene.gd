extends Control

@onready var picture = $TextureRect
@onready var credits_label = $VBoxContainer/Label
@onready var timer_label = $VBoxContainer/TimerLabel
@onready var canvas_modulate = $CanvasModulate

func _ready():
	# Ensure the picture is visible
	picture.modulate.a = 1.0
	
	# Set initial transparency for labels
	credits_label.modulate.a = 0.0
	timer_label.modulate.a = 0.0
	
	# Get final time from global_game_data
	var final_time = get_node("/root").get("global_game_data").final_time if get_node("/root").get("global_game_data") != null else 0.0
	var minutes = int(final_time / 60)
	var seconds = int(final_time) % 60
	timer_label.text = "Time: %02d:%02d" % [minutes, seconds]
	credits_label.text = "Game by Your Name\nThanks for Playing!"
	
	# Start the cutscene sequence
	start_cutscene()

func start_cutscene():
	# Wait for 2 seconds before fading in labels
	await get_tree().create_timer(2.0).timeout
	
	# Fade in both labels over 3 seconds
	var tween = create_tween()
	tween.parallel().tween_property(credits_label, "modulate:a", 1.0, 3.0)
	tween.parallel().tween_property(timer_label, "modulate:a", 1.0, 3.0)
	
	# Wait after labels are fully visible
	await tween.finished
	await get_tree().create_timer(5.0).timeout
	
	# Transition to main menu
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
