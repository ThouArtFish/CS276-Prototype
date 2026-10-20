class_name BlockSwatch
extends Control
# One block in the sidebar. Pressing it asks Main to start a drag.

signal picked(block_type: int)

@export var block_type := 0

# Only used by the thruster swatch, so it shows the current direction.
var direction := 0
var enabled := true


func _ready() -> void:
	gui_input.connect(_on_gui_input)


# Disabled swatches are dimmed and cannot be dragged.
func set_enabled(on: bool) -> void:
	enabled = on
	modulate.a = 1.0 if on else 0.3


func set_direction(dir: int) -> void:
	direction = dir
	queue_redraw()


func _draw() -> void:
	BlockArt.draw_block(self, Rect2(Vector2.ZERO, size), block_type, direction)


func _on_gui_input(event: InputEvent) -> void:
	if not enabled:
		return
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		if mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT:
			picked.emit(block_type)
