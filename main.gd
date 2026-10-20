extends Node
# Wires the world nodes and the UI nodes together and switches between
# building and running. The game logic lives in the other nodes.

@onready var grid: BlockGrid = $World/BlockGrid
@onready var rocket: Rocket = $World/Rocket
@onready var camera: ViewCamera = $World/ViewCamera
@onready var sidebar: Sidebar = $UI/Sidebar
@onready var right_panel: RightPanel = $UI/RightPanel
@onready var ghost: DragGhost = $UI/DragGhost
@onready var status_label: Label = $UI/StatusLabel

# Direction used for the next thruster that is dragged out.
var thruster_dir := 0
var running := false


func _ready() -> void:
	RenderingServer.set_default_clear_color(Config.BACKGROUND)

	sidebar.block_picked.connect(_on_block_picked)
	sidebar.erase_toggled.connect(_on_erase_toggled)
	sidebar.clear_pressed.connect(grid.clear)

	ghost.moved.connect(_on_ghost_moved)
	ghost.released.connect(_on_ghost_released)
	ghost.direction_changed.connect(_on_ghost_direction_changed)

	right_panel.up_held_changed.connect(camera.set_up_held)
	right_panel.down_held_changed.connect(camera.set_down_held)
	right_panel.start_pressed.connect(_on_start_pressed)
	right_panel.reset_pressed.connect(_end_run)
	camera.height_changed.connect(right_panel.set_height)
	right_panel.set_height(camera.get_height())

	rocket.goal_reached.connect(_on_goal_reached)


func _on_block_picked(block_type: int) -> void:
	if running:
		return
	ghost.begin(block_type, thruster_dir, get_viewport().get_mouse_position())


func _on_erase_toggled(on: bool) -> void:
	grid.erase_mode = on
	ghost.cancel()


func _on_ghost_moved(screen_pos: Vector2) -> void:
	var cell := grid.screen_to_cell(screen_pos)
	if grid.in_bounds(cell):
		ghost.snap_to(grid.cell_to_screen(cell))
	else:
		ghost.float_at(screen_pos)


func _on_ghost_released(block_type: int, dir: int, screen_pos: Vector2) -> void:
	grid.place(grid.screen_to_cell(screen_pos), block_type, dir)


func _on_ghost_direction_changed(dir: int) -> void:
	thruster_dir = dir
	sidebar.set_thruster_direction(dir)


func _on_start_pressed() -> void:
	if running:
		return
	running = true
	status_label.hide()
	ghost.cancel()
	grid.set_running(true)
	sidebar.set_locked(true)
	right_panel.set_running(true)
	rocket.launch(grid)


# Ends the current run and returns to building. Used by the reset button
# and when the goal is reached.
func _end_run() -> void:
	if not running:
		return
	running = false
	rocket.stop()
	grid.set_running(false)
	sidebar.set_locked(false)
	right_panel.set_running(false)


func _on_goal_reached() -> void:
	if not running:
		return
	status_label.show()
	_end_run()
