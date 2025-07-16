@tool
extends TileMap

var source_id: int = 1

# Tile configurations for 31 variations:
# 0–15: Based on cardinal neighbors (top, right, bottom, left)
# 16–30: When all cardinal neighbors are present (bitmask 15), based on diagonal neighbors
var tile_configs: Dictionary = {
	0: Vector2i(2, 2),    # No cardinal neighbors
	1: Vector2i(3, 1),    # Top
	2: Vector2i(0, 1),    # Right
	3: Vector2i(3, 0),    # Top, Right
	4: Vector2i(2, 1),    # Bottom
	5: Vector2i(1, 2),    # Top, Bottom
	6: Vector2i(0, 0),    # Right, Bottom
	7: Vector2i(3, 3),    # Top, Right, Bottom
	8: Vector2i(1, 1),    # Left
	9: Vector2i(2, 0),    # Top, Left
	10: Vector2i(0, 2),   # Right, Left
	11: Vector2i(2, 3),   # Top, Right, Left
	12: Vector2i(1, 0),   # Bottom, Left
	13: Vector2i(1, 3),   # Top, Bottom, Left
	14: Vector2i(0, 3),   # Right, Bottom, Left
	15: Vector2i(2,6),   # Top, Right, Bottom, Left (no diagonals)
	# Diagonal configurations when all cardinal neighbors are present
	16: Vector2i(3,7),   # Top-Left
	17: Vector2i(2, 7),   # Top-Right
	18: Vector2i(0,5),   # Top-Left, Top-Right
	19: Vector2i(0, 7),   # Bottom-Left
	20: Vector2i(5, 0),   # Top-Left, Bottom-Left
	21: Vector2i(3,5),   # Top-Right, Bottom-Left
	22: Vector2i(3,4),   # Top-Left, Top-Right, Bottom-Left
	23: Vector2i(1,7),   # Bottom-Right
	24: Vector2i(1,6),   # Top-Left, Bottom-Right
	25: Vector2i(1,5),   # Top-Right, Bottom-Right
	26: Vector2i(2,4),   # Top-Left, Top-Right, Bottom-Right
	27: Vector2i(2,5),   # Bottom-Left, Bottom-Right
	28: Vector2i(1,4),   # Top-Left, Bottom-Left, Bottom-Right
	29: Vector2i(0,4),   # Top-Right, Bottom-Left, Bottom-Right
	30: Vector2i(3,6)    # Top-Left, Top-Right, Bottom-Left, Bottom-Right
}

func _ready() -> void:
	if not Engine.is_editor_hint():
		update_all_tiles()

func update_all_tiles(target_source_id: int = source_id) -> void:
	var layer_count = get_layers_count()
	for layer in range(layer_count):
		var used_cells: Array[Vector2i] = get_used_cells(layer)
		for cell in used_cells:
			if get_cell_source_id(layer, cell) == target_source_id:
				update_tile(layer, cell)

func update_tile(layer: int, cell: Vector2i) -> void:
	var bitmask: int = 0
	# Check four cardinal neighbors
	if get_cell_source_id(layer, cell + Vector2i(0, -1)) != -1:  # Top
		bitmask |= 1
	if get_cell_source_id(layer, cell + Vector2i(1, 0)) != -1:   # Right
		bitmask |= 2
	if get_cell_source_id(layer, cell + Vector2i(0, 1)) != -1:   # Bottom
		bitmask |= 4
	if get_cell_source_id(layer, cell + Vector2i(-1, 0)) != -1:  # Left
		bitmask |= 8
	
	# If all cardinal neighbors are present (bitmask 15), check diagonals
	if bitmask == 15:
		var diagonal_bitmask: int = 0
		if get_cell_source_id(layer, cell + Vector2i(-1, -1)) != -1: # Top-Left
			diagonal_bitmask |= 1
		if get_cell_source_id(layer, cell + Vector2i(1, -1)) != -1:  # Top-Right
			diagonal_bitmask |= 2
		if get_cell_source_id(layer, cell + Vector2i(-1, 1)) != -1:  # Bottom-Left
			diagonal_bitmask |= 4
		if get_cell_source_id(layer, cell + Vector2i(1, 1)) != -1:   # Bottom-Right
			diagonal_bitmask |= 8
		# Map diagonal configurations to bitmask 16–30
		if diagonal_bitmask > 0:
			bitmask = 15 + diagonal_bitmask
	
	var atlas_coords: Vector2i = tile_configs.get(bitmask, Vector2i(0, 0))
	set_cell(layer, cell, source_id, atlas_coords)

func on_tilemap_changed(cell: Vector2i) -> void:
	var layer_count = get_layers_count()
	for layer in range(layer_count):
		# Update the center tile and all 8 surrounding tiles
		update_tile(layer, cell)
		update_tile(layer, cell + Vector2i(-1, -1)) # Top-Left
		update_tile(layer, cell + Vector2i(0, -1))  # Top
		update_tile(layer, cell + Vector2i(1, -1))  # Top-Right
		update_tile(layer, cell + Vector2i(-1, 0))  # Left
		update_tile(layer, cell + Vector2i(1, 0))   # Right
		update_tile(layer, cell + Vector2i(-1, 1))  # Bottom-Left
		update_tile(layer, cell + Vector2i(0, 1))   # Bottom
		update_tile(layer, cell + Vector2i(1, 1))   # Bottom-Right
