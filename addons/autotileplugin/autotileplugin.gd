@tool
extends EditorPlugin

var button: Button
var editor_interface: EditorInterface
@export var source_id: int = 3  # Configurable in the editor

func _enter_tree() -> void:
	editor_interface = get_editor_interface()
	button = Button.new()
	button.text = "Autotile Selected Tiles"
	button.pressed.connect(_on_button_pressed)
	add_control_to_bottom_panel(button, "Autotile")

func _on_button_pressed() -> void:
	print("Button pressed")
	var selection = editor_interface.get_selection()
	var selected_nodes = selection.get_selected_nodes()
	print("Selected nodes:", selected_nodes)  # Debug
	for node in selected_nodes:
		if node is TileMap:
			var tilemap: TileMap = node
			print("Processing TileMap:", tilemap.name)
			if tilemap.has_method("update_all_tiles"):
				tilemap.update_all_tiles(source_id)
				editor_interface.mark_scene_as_unsaved()

func _exit_tree() -> void:
	if button:
		button.queue_free()
