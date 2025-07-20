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
var is_animating = false
var tween: Tween

func _ready():
	# Validate PageContainer size
	if page_container.size.x == 0:
		push_warning("PageContainer size.x is 0! Set rect_min_size in the editor.")
		page_container.rect_min_size = Vector2(1920, 1080)  # Adjust to your PNG resolution
	
	# Initialize
	current_page.texture = pages[current_index]
	current_page.position = Vector2(0, 0)
	current_page.scale = Vector2(1, 1)
	current_page.modulate.a = 1.0
	current_page.visible = true
	next_page.texture = null
	next_page.position = Vector2(0, 0)
	next_page.scale = Vector2(0, 1)
	next_page.modulate.a = 1.0
	next_page.visible = false
	left_button.pressed.connect(_on_prev_pressed)
	right_button.pressed.connect(_on_next_pressed)
	start_button.pressed.connect(_on_start_pressed)
	update_buttons()
	# Debug initial state
	print("=== Initial State ===")
	print("PageContainer size:", page_container.size)
	print("CurrentPage: texture=", current_page.texture, " pos=", current_page.position, " scale=", current_page.scale, " pivot=", current_page.pivot_offset, " visible=", current_page.visible)
	print("NextPage: texture=", next_page.texture, " pos=", next_page.position, " scale=", next_page.scale, " pivot=", next_page.pivot_offset, " visible=", next_page.visible)

func update_buttons():
	left_button.disabled = current_index == 0
	right_button.visible = current_index < pages.size() - 1
	start_button.visible = current_index == pages.size() - 1

func _on_prev_pressed():
	if is_animating or current_index == 0:
		return
	animate_page_flip(current_index - 1, -1)  # Flip from right to left for previous

func _on_next_pressed():
	if is_animating or current_index >= pages.size() - 1:
		return
	animate_page_flip(current_index + 1, 1)  # Flip from left to right for next

func animate_page_flip(new_index: int, direction: float) -> void:
	if is_animating:
		return
	is_animating = true

	# Stop any existing tween
	if tween:
		tween.kill()

	tween = create_tween()

	# Set up next page
	next_page.texture = pages[new_index]
	next_page.position = Vector2(0, 0)
	next_page.scale = Vector2(0, 1)
	next_page.modulate.a = 1.0
	next_page.visible = true
	# Set pivot to left edge for "Next" (direction = 1), right edge for "Previous" (direction = -1)
	next_page.pivot_offset = Vector2(0 if direction > 0 else page_container.size.x, page_container.size.y / 2)

	# Debug animation start
	print("=== Animation Start (Index:", new_index, " Direction:", direction, ") ===")
	print("CurrentPage: pos=", current_page.position, " scale=", current_page.scale, " pivot=", current_page.pivot_offset, " visible=", current_page.visible)
	print("NextPage: pos=", next_page.position, " scale=", next_page.scale, " pivot=", next_page.pivot_offset, " visible=", next_page.visible)

	# Page flip animation: scale next_page horizontally
	tween.tween_property(next_page, "scale", Vector2(direction, 1), 0.7).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(current_page, "modulate:a", 0.0, 0.35).set_trans(Tween.TRANS_SINE)  # Fade out current page halfway
	tween.tween_callback(_on_tween_finished.bind(new_index))

func _on_tween_finished(new_index: int):
	# Update current page
	current_page.texture = pages[new_index]
	current_page.scale = Vector2(1, 1)
	current_page.modulate.a = 1.0
	current_page.visible = true
	current_page.pivot_offset = Vector2(0, page_container.size.y / 2)  # Reset pivot
	# Reset next page
	next_page.texture = null
	next_page.scale = Vector2(0, 1)
	next_page.modulate.a = 1.0
	next_page.visible = false
	next_page.pivot_offset = Vector2(0, page_container.size.y / 2)
	current_index = new_index
	is_animating = false
	update_buttons()
	# Debug animation end
	print("=== Animation End (Index:", new_index, ") ===")
	print("CurrentPage: texture=", current_page.texture, " pos=", current_page.position, " scale=", current_page.scale, " pivot=", current_page.pivot_offset, " visible=", current_page.visible)
	print("NextPage: texture=", next_page.texture, " pos=", next_page.position, " scale=", next_page.scale, " pivot=", next_page.pivot_offset, " visible=", next_page.visible)

func _on_start_pressed():
	print("Starting game...")
	get_tree().change_scene_to_file("res://scenes/game.tscn")
