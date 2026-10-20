extends Node2D
# Draws the tall background strip, its edges, height markers, the goal line
# and the floor.


func _draw() -> void:
	var font := ThemeDB.fallback_font

	# Background gradient made of horizontal bands.
	var band := 40
	var bands := int(Config.STRIP_H / float(band))
	var top_col := Color(0.05, 0.07, 0.16)
	var bottom_col := Color(0.20, 0.30, 0.45)
	for i in bands:
		var t := float(i) / float(bands - 1)
		draw_rect(Rect2(Config.STRIP_X, i * band, Config.STRIP_W, band), top_col.lerp(bottom_col, t))

	# Strip edges.
	var edge := Color(1, 1, 1, 0.35)
	var right_x := Config.STRIP_X + Config.STRIP_W
	draw_line(Vector2(Config.STRIP_X, 0), Vector2(Config.STRIP_X, Config.STRIP_H), edge, 3.0)
	draw_line(Vector2(right_x, 0), Vector2(right_x, Config.STRIP_H), edge, 3.0)

	# Height markers every 4 cells.
	var step := Config.CELL * 4
	for h in range(step, Config.STRIP_H, step):
		var y := Config.STRIP_H - h
		draw_line(Vector2(Config.STRIP_X, y), Vector2(right_x, y), Color(1, 1, 1, 0.12), 2.0)
		draw_string(font, Vector2(Config.STRIP_X + 12, y - 8), "%d m" % roundi(h / float(Config.CELL)),
				HORIZONTAL_ALIGNMENT_LEFT, -1, 18, Color(1, 1, 1, 0.45))

	# Marker for the highest point the view can reach.
	var max_y := int(Config.START_Y - Config.MAX_SCROLL)
	draw_line(Vector2(Config.STRIP_X, max_y), Vector2(right_x, max_y), Color(1, 0.8, 0.3, 0.8), 3.0)
	draw_string(font, Vector2(Config.STRIP_X, max_y + 34), "MAX HEIGHT",
			HORIZONTAL_ALIGNMENT_CENTER, Config.STRIP_W, 22, Color(1, 0.8, 0.3, 0.9))

	# Goal line drawn as a dashed line.
	var goal_col := Color(0.4, 1.0, 0.5, 0.9)
	var x := float(Config.STRIP_X)
	while x < right_x:
		draw_line(Vector2(x, Config.GOAL_Y), Vector2(minf(x + 24.0, right_x), Config.GOAL_Y), goal_col, 4.0)
		x += 40.0
	draw_string(font, Vector2(Config.STRIP_X, Config.GOAL_Y - 10), "GOAL HEIGHT",
			HORIZONTAL_ALIGNMENT_CENTER, Config.STRIP_W, 22, goal_col)

	# Floor under the grid.
	var grid_bottom := Config.GRID_ORIGIN.y + Config.ROWS * Config.CELL
	draw_rect(Rect2(Config.STRIP_X, grid_bottom, Config.STRIP_W, Config.GRID_BOTTOM_MARGIN), Color(0.10, 0.09, 0.10))
