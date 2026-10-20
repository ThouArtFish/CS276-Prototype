extends StaticBody2D
# Invisible floor and side walls so the rocket stays inside the strip.


func _ready() -> void:
	var floor_top := Config.GRID_ORIGIN.y + Config.ROWS * Config.CELL
	var right_x := Config.STRIP_X + Config.STRIP_W
	var wall_top := -1000.0
	var wall_height := Config.STRIP_H + 1000.0 + 200.0

	_add_box(Rect2(Config.STRIP_X - 200, floor_top, Config.STRIP_W + 400, 200))
	_add_box(Rect2(Config.STRIP_X - 200, wall_top, 200, wall_height))
	_add_box(Rect2(right_x, wall_top, 200, wall_height))


func _add_box(rect: Rect2) -> void:
	var shape := RectangleShape2D.new()
	shape.size = rect.size
	var node := CollisionShape2D.new()
	node.shape = shape
	node.position = rect.get_center()
	add_child(node)
