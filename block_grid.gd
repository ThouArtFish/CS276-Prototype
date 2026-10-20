class_name BlockGrid
extends Node2D
# Holds the block data, draws the grid and handles erase clicks.
# The node sits at the grid origin so everything is drawn in local space.

const EMPTY := -1

# When true, clicking a block deletes it.
var erase_mode := false
# While a run is in progress the blocks are drawn by the rocket instead.
var running := false
# Flat arrays of COLS times ROWS entries. Type is EMPTY or a block type.
# Direction only matters for thrusters.
var cells := PackedInt32Array()
var dirs := PackedInt32Array()


func _ready() -> void:
	position = Config.GRID_ORIGIN
	cells.resize(Config.COLS * Config.ROWS)
	dirs.resize(Config.COLS * Config.ROWS)
	cells.fill(EMPTY)
	dirs.fill(0)


func in_bounds(cell: Vector2i) -> bool:
	return cell.x >= 0 and cell.y >= 0 and cell.x < Config.COLS and cell.y < Config.ROWS


func get_block(cell: Vector2i) -> int:
	if not in_bounds(cell):
		return EMPTY
	return cells[cell.y * Config.COLS + cell.x]


func get_dir(cell: Vector2i) -> int:
	if not in_bounds(cell):
		return 0
	return dirs[cell.y * Config.COLS + cell.x]


# Placing a block replaces whatever was in the cell.
func place(cell: Vector2i, block_type: int, dir: int = 0) -> void:
	if not in_bounds(cell) or running:
		return
	cells[cell.y * Config.COLS + cell.x] = block_type
	dirs[cell.y * Config.COLS + cell.x] = dir
	queue_redraw()


func erase(cell: Vector2i) -> void:
	if get_block(cell) == EMPTY or running:
		return
	cells[cell.y * Config.COLS + cell.x] = EMPTY
	dirs[cell.y * Config.COLS + cell.x] = 0
	queue_redraw()


func clear() -> void:
	if running:
		return
	cells.fill(EMPTY)
	dirs.fill(0)
	queue_redraw()


func set_running(on: bool) -> void:
	running = on
	queue_redraw()


# World position of the middle of a cell.
func cell_center_world(cell: Vector2i) -> Vector2:
	return Config.GRID_ORIGIN + (Vector2(cell) + Vector2(0.5, 0.5)) * Config.CELL


# Converts a screen position to a grid cell, taking the camera into account.
func screen_to_cell(screen_pos: Vector2) -> Vector2i:
	var local := get_global_transform_with_canvas().affine_inverse() * screen_pos
	return Vector2i(floori(local.x / Config.CELL), floori(local.y / Config.CELL))


# Screen position of the top left corner of a cell.
func cell_to_screen(cell: Vector2i) -> Vector2:
	return get_global_transform_with_canvas() * (Vector2(cell) * Config.CELL)


func _unhandled_input(event: InputEvent) -> void:
	if not erase_mode or running:
		return
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT:
			erase(screen_to_cell(mb.position))


func _draw() -> void:
	var cell_size := Vector2(Config.CELL, Config.CELL)

	for y in Config.ROWS:
		for x in Config.COLS:
			var r := Rect2(Vector2(x, y) * Config.CELL, cell_size)
			var base := Color(0.16, 0.18, 0.24) if (x + y) % 2 == 0 else Color(0.19, 0.21, 0.28)
			draw_rect(r, base)
			var type := cells[y * Config.COLS + x]
			if type != EMPTY and not running:
				BlockArt.draw_block(self, r, type, dirs[y * Config.COLS + x])

	# Grid lines and outline.
	var line_col := Color(1, 1, 1, 0.08)
	var total := Vector2(Config.COLS * Config.CELL, Config.ROWS * Config.CELL)
	for i in Config.COLS + 1:
		draw_line(Vector2(i * Config.CELL, 0), Vector2(i * Config.CELL, total.y), line_col, 1.0)
	for i in Config.ROWS + 1:
		draw_line(Vector2(0, i * Config.CELL), Vector2(total.x, i * Config.CELL), line_col, 1.0)
	draw_rect(Rect2(Vector2.ZERO, total), Color(1, 1, 1, 0.5), false, 2.0)
