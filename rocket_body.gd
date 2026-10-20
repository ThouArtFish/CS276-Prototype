class_name RocketBody
extends RigidBody2D
# One connected group of blocks flying as a single rigid body.
# Thrusters push, goal blocks report when they reach the goal height.

signal goal_reached


class BlockInfo:
	var pos: Vector2
	var type: int
	var dir: int


var blocks: Array[BlockInfo] = []


func _ready() -> void:
	can_sleep = false
	linear_damp = Config.LINEAR_DAMP
	angular_damp = Config.ANGULAR_DAMP
	continuous_cd = RigidBody2D.CCD_MODE_CAST_SHAPE


# Position is relative to the body origin.
func add_block(local_pos: Vector2, type: int, dir: int) -> void:
	var info := BlockInfo.new()
	info.pos = local_pos
	info.type = type
	info.dir = dir
	blocks.append(info)

	var rect := RectangleShape2D.new()
	rect.size = Vector2(Config.CELL, Config.CELL)
	var shape := CollisionShape2D.new()
	shape.shape = rect
	shape.position = local_pos
	add_child(shape)
	queue_redraw()


func _physics_process(_delta: float) -> void:
	for info in blocks:
		var world_pos := to_global(info.pos)
		if info.type == Config.THRUSTER:
			# The thruster turns with the rocket, so rotate its direction too.
			var force := Config.DIRECTIONS[info.dir].rotated(rotation) * Config.THRUST
			apply_force(force, world_pos - global_position)
		elif info.type == Config.GOAL and world_pos.y <= Config.GOAL_Y:
			goal_reached.emit()
			return


func _draw() -> void:
	var half := Vector2(Config.CELL, Config.CELL) / 2.0
	for info in blocks:
		BlockArt.draw_block(self, Rect2(info.pos - half, half * 2.0), info.type, info.dir)
