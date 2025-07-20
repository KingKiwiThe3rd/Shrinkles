extends Control

@onready var animated_sprite = $AnimatedSprite2D
@onready var start_button = $VBoxContainer/StartButton
@onready var quit_button = $VBoxContainer/QuitButton

func _ready():
	# Ensure the animation loops
	animated_sprite.play()
	
	# Connect button signals
	start_button.pressed.connect(_on_start_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)

func _on_start_button_pressed():
	# Transition to the game scene (replace with your game scene path)
	get_tree().change_scene_to_file("res://Scenes/comic_cutscene.tscn")


func _on_quit_button_pressed():
	# Quit the game
	get_tree().quit()
