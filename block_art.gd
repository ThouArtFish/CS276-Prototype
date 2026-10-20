class_name BlockArt
extends RefCounted
# Draws one block. Shared by the grid, the sidebar, the drag ghost and the
# flying rocket so a block always looks the same.


# Call this from inside the draw function of the given item.
static func draw_block(item: CanvasItem, rect: Rect2, type: int, dir: int) -> void:
	var color := Config.BLOCK_COLORS[type]
	var inner := rect.grow(-3.0)
	item.draw_rect(inner, color)
	item.draw_rect(inner, color.darkened(0.4), false, 3.0)
	match type:
		Config.THRUSTER:
			_draw_arrow(item, inner, dir)
		Config.GOAL:
			_draw_letter(item, inner, "G")


static func _draw_arrow(item: CanvasItem, rect: Rect2, dir: int) -> void:
	var v: Vector2 = Config.DIRECTIONS[dir]
	var side := v.orthogonal()
	var center := rect.get_center()
	var s := rect.size.x
	var tail := center - v * s * 0.3
	var base := center + v * s * 0.02
	var tip := center + v * s * 0.34
	item.draw_line(tail, base, Color.WHITE, s * 0.12)
	item.draw_colored_polygon(
			PackedVector2Array([tip, base + side * s * 0.22, base - side * s * 0.22]), Color.WHITE)


static func _draw_letter(item: CanvasItem, rect: Rect2, text: String) -> void:
	var font := ThemeDB.fallback_font
	var font_size := int(rect.size.y * 0.5)
	item.draw_string(font, Vector2(rect.position.x, rect.get_center().y + font_size * 0.35), text,
			HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, font_size, Color.WHITE)
