extends Control

@onready var picture = $TextureRect
@onready var credits_label = $Label
@onready var canvas_modulate = $CanvasModulate

func _ready():
	# Ensure the picture is visible
	picture.modulate.a = 1.0
	
	# Set initial credits transparency to 0 (invisible)
	credits_label.modulate.a = 0.0
	
	# Start the cutscene sequence
	start_cutscene()

func start_cutscene():
	# Wait for 2 seconds before fading in credits
	await get_tree().create_timer(2.0).timeout
	
	# Fade in credits over 3 seconds
	var tween = create_tween()
	tween.tween_property(credits_label, "modulate:a", 1.0, 3.0)
	
	# Wait after credits are fully visible
	await tween.finished
	await get_tree().create_timer(5.0).timeout
	
	# Signal that cutscene is complete
	emit_signal("cutscene_finished")
	

signal cutscene_finished
