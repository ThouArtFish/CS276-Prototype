class_name ViewCamera
extends Camera2D
# Moves the game view up and down along the strip.

signal height_changed(height: float)

var up_held := false
var down_held := false
# World y of the top of the screen.
var view_y := float(Config.START_Y)


func _ready() -> void:
	position = Vector2(0.0, view_y)


func set_up_held(held: bool) -> void:
	up_held = held


func set_down_held(held: bool) -> void:
	down_held = held


# How far the view has moved up from the start.
func get_height() -> float:
	return Config.START_Y - view_y


func _process(delta: float) -> void:
	var dir := int(down_held) - int(up_held)
	if dir == 0:
		return
	var min_y := Config.START_Y - Config.MAX_SCROLL
	view_y = clampf(view_y + dir * Config.SCROLL_SPEED * delta, min_y, Config.START_Y)
	position.y = view_y
	height_changed.emit(get_height())
