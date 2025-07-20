extends Control

@onready var page_container = $PageContainer
@onready var current_page = $PageContainer/CurrentPage
@onready var next_page = $PageContainer/NextPage
@onready var left_button = $LeftButton
@onready var right_button = $RightButton
@onready var start_button = $StartButton

var pages = [
	preload("res://comics/comicpage1.png"),
	preload("res://comics/comicpage2.png"),
	preload("res://comics/comicpage3.png")
]

var current_index = 0

func _ready():
	# Initialize
	current_page.texture = pages[current_index]
	current_page.position = Vector2(0, 0)
	next_page.visible = false  # Hide next page
	left_button.pressed.connect(_on_prev_pressed)
	right_button.pressed.connect(_on_next_pressed)
	start_button.pressed.connect(_on_start_pressed)
	update_buttons()
	# Debug initial state
	print("Initial state: Current page texture:", current_page.texture, " Position:", current_page.position)

func update_buttons():
	left_button.disabled = current_index == 0
	right_button.visible = current_index < pages.size() - 1
	start_button.visible = current_index == pages.size() - 1

func _on_prev_pressed():
	if current_index > 0:
		current_index -= 1
		current_page.texture = pages[current_index]
		update_buttons()
		print("Prev: Index:", current_index, " Texture:", current_page.texture)

func _on_next_pressed():
	if current_index < pages.size() - 1:
		current_index += 1
		current_page.texture = pages[current_index]
		update_buttons()
		print("Next: Index:", current_index, " Texture:", current_page.texture)

func _on_start_pressed():
	print("Starting game...")
	get_tree().change_scene_to_file("res://scenes/game.tscn")
