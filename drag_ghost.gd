class_name DragGhost
extends Control
# Semi transparent block that follows the mouse while a block is being dragged.
# Pressing R while dragging a thruster turns it a quarter turn.

signal moved(screen_pos: Vector2)
signal released(block_type: int, dir: int, screen_pos: Vector2)
signal direction_changed(dir: int)

var block_type := -1
var direction := 0


func _ready() -> void:
	visible = false
	set_process_input(false)


func begin(type: int, dir: int, screen_pos: Vector2) -> void:
	block_type = type
	direction = dir
	visible = true
	set_process_input(true)
	queue_redraw()
	moved.emit(screen_pos)


func cancel() -> void:
	block_type = -1
	visible = false
	set_process_input(false)


# Used when the mouse is over a grid cell, so the ghost sits exactly on it.
func snap_to(screen_pos: Vector2) -> void:
	position = screen_pos
	modulate.a = 0.9


# Used when the mouse is outside the grid, so the ghost is centred on it.
func float_at(screen_pos: Vector2) -> void:
	position = screen_pos - size / 2.0
	modulate.a = 0.55


func _draw() -> void:
	if block_type >= 0:
		BlockArt.draw_block(self, Rect2(Vector2.ZERO, size), block_type, direction)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		moved.emit((event as InputEventMouseMotion).position)
	elif event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_LEFT and not mb.pressed:
			var type := block_type
			var dir := direction
			cancel()
			released.emit(type, dir, mb.position)
	elif event is InputEventKey:
		var key := event as InputEventKey
		if key.pressed and not key.echo and key.keycode == KEY_R and block_type == Config.THRUSTER:
			direction = (direction + 1) % Config.DIRECTIONS.size()
			queue_redraw()
			direction_changed.emit(direction)
