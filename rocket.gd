class_name Rocket
extends Node2D
# Builds physics bodies from the grid when a run starts and removes them
# when it ends. Each group of touching blocks becomes its own rigid body.
# This node sits at the world origin so local and world positions match.

signal goal_reached

const NEIGHBOURS: Array[Vector2i] = [
	Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1),
]


func launch(grid: BlockGrid) -> void:
	stop()
	var visited := {}
	for y in Config.ROWS:
		for x in Config.COLS:
			var cell := Vector2i(x, y)
			if grid.get_block(cell) == BlockGrid.EMPTY or visited.has(cell):
				continue
			_spawn_body(grid, _collect_group(grid, cell, visited))


func stop() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()


# Flood fill over blocks that touch along an edge.
func _collect_group(grid: BlockGrid, start: Vector2i, visited: Dictionary) -> Array[Vector2i]:
	var group: Array[Vector2i] = []
	var stack: Array[Vector2i] = [start]
	visited[start] = true
	while not stack.is_empty():
		var cell: Vector2i = stack.pop_back()
		group.append(cell)
		for offset in NEIGHBOURS:
			var next := cell + offset
			if not visited.has(next) and grid.get_block(next) != BlockGrid.EMPTY:
				visited[next] = true
				stack.append(next)
	return group


func _spawn_body(grid: BlockGrid, group: Array[Vector2i]) -> void:
	var center := Vector2.ZERO
	for cell in group:
		center += grid.cell_center_world(cell)
	center /= group.size()

	var body := RocketBody.new()
	body.position = center
	body.mass = Config.BLOCK_MASS * group.size()
	for cell in group:
		body.add_block(grid.cell_center_world(cell) - center, grid.get_block(cell), grid.get_dir(cell))
	body.goal_reached.connect(_on_body_goal_reached)
	add_child(body)


func _on_body_goal_reached() -> void:
	goal_reached.emit()
