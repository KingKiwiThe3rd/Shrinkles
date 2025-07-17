@tool
extends EditorPlugin

var button: Button
var spin_box: SpinBox
var container: HBoxContainer
var editor_interface: EditorInterface

# This is the placeholder source ID we detect in the TileMap
const PLACEHOLDER_SOURCE_ID := 3

func _enter_tree() -> void:
	editor_interface = get_editor_interface()

	# Container for SpinBox + Button
	container = HBoxContainer.new()

	# Create SpinBox for target source ID input
	spin_box = SpinBox.new()
	spin_box.min_value = 0
	spin_box.max_value = 9999
	spin_box.step = 1
	spin_box.value = 0
	spin_box.custom_minimum_size = Vector2(80, 0)
	spin_box.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	container.add_child(spin_box)

	# Create and connect Button
	button = Button.new()
	button.text = "Autotile Placeholder Tiles"
	button.pressed.connect(_on_button_pressed)
	container.add_child(button)

	# Add to bottom panel
	add_control_to_bottom_panel(container, "Autotile")

func _on_button_pressed() -> void:
	var target_source_id = int(spin_box.value)
	print("Replacing tiles from ID", PLACEHOLDER_SOURCE_ID, "to", target_source_id)

	var selection = editor_interface.get_selection()
	var selected_nodes = selection.get_selected_nodes()

	for node in selected_nodes:
		if node is TileMap:
			if node.has_method("update_all_tiles"):
				node.update_all_tiles(PLACEHOLDER_SOURCE_ID, target_source_id)
				editor_interface.mark_scene_as_unsaved()
			else:
				push_error("TileMap does not have 'update_all_tiles' method!")

func _exit_tree() -> void:
	if container:
		container.queue_free()
