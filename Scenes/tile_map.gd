@tool
extends TileMap

var source_id: int = 2  # Default fallback value, can be used outside the plugin

# Tile configurations for 31 variations
var tile_configs: Dictionary = {
	0: Vector2i(2, 2),
	1: Vector2i(3, 1),
	2: Vector2i(0, 1),
	3: Vector2i(3, 0),
	4: Vector2i(2, 1),
	5: Vector2i(1, 2),
	6: Vector2i(0, 0),
	7: Vector2i(3, 3),
	8: Vector2i(1, 1),
	9: Vector2i(2, 0),
	10: Vector2i(0, 2),
	11: Vector2i(2, 3),
	12: Vector2i(1, 0),
	13: Vector2i(1, 3),
	14: Vector2i(0, 3),
	15: Vector2i(2, 6),
	16: Vector2i(3, 7),
	17: Vector2i(2, 7),
	18: Vector2i(0, 5),
	19: Vector2i(0, 7),
	20: Vector2i(3, 5),
	21: Vector2i(2, 6),
	22: Vector2i(3, 4),
	23: Vector2i(1, 7),
	24: Vector2i(1, 6),
	25: Vector2i(1, 5),
	26: Vector2i(2, 4),
	27: Vector2i(2, 5),
	28: Vector2i(1, 4),
	29: Vector2i(0, 4),
	30: Vector2i(3, 6)
}

func _ready() -> void:
	if not Engine.is_editor_hint():
		update_all_tiles()

func update_all_tiles(detect_id: int = source_id, new_id: int = source_id) -> void:
	var layer_count = get_layers_count()
	for layer in range(layer_count):
		var used_cells: Array[Vector2i] = get_used_cells(layer)
		for cell in used_cells:
			if get_cell_source_id(layer, cell) == detect_id:
				update_tile(layer, cell, new_id)

func update_tile(layer: int, cell: Vector2i, place_id: int) -> void:
	var bitmask: int = 0

	# Check cardinal directions
	if get_cell_source_id(layer, cell + Vector2i(0, -1)) != -1:  # Top
		bitmask |= 1
	if get_cell_source_id(layer, cell + Vector2i(1, 0)) != -1:   # Right
		bitmask |= 2
	if get_cell_source_id(layer, cell + Vector2i(0, 1)) != -1:   # Bottom
		bitmask |= 4
	if get_cell_source_id(layer, cell + Vector2i(-1, 0)) != -1:  # Left
		bitmask |= 8

	# Check diagonals if surrounded
	if bitmask == 15:
		var diagonal_bitmask: int = 0
		if get_cell_source_id(layer, cell + Vector2i(-1, -1)) != -1: diagonal_bitmask |= 1
		if get_cell_source_id(layer, cell + Vector2i(1, -1)) != -1:  diagonal_bitmask |= 2
		if get_cell_source_id(layer, cell + Vector2i(-1, 1)) != -1:  diagonal_bitmask |= 4
		if get_cell_source_id(layer, cell + Vector2i(1, 1)) != -1:   diagonal_bitmask |= 8
		if diagonal_bitmask > 0:
			bitmask = 15 + diagonal_bitmask

	var atlas_coords: Vector2i = tile_configs.get(bitmask, Vector2i(0, 0))
	set_cell(layer, cell, place_id, atlas_coords)

func on_tilemap_changed(cell: Vector2i) -> void:
	var layer_count = get_layers_count()
	for layer in range(layer_count):
		# Update center + 8 surrounding tiles
		update_tile(layer, cell, source_id)
		update_tile(layer, cell + Vector2i(-1, -1), source_id)
		update_tile(layer, cell + Vector2i(0, -1), source_id)
		update_tile(layer, cell + Vector2i(1, -1), source_id)
		update_tile(layer, cell + Vector2i(-1, 0), source_id)
		update_tile(layer, cell + Vector2i(1, 0), source_id)
		update_tile(layer, cell + Vector2i(-1, 1), source_id)
		update_tile(layer, cell + Vector2i(0, 1), source_id)
		update_tile(layer, cell + Vector2i(1, 1), source_id)
