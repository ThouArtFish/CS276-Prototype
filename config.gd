class_name Config
extends RefCounted
# Shared layout and gameplay constants used by every node.

const VIEW_W := 1280
const VIEW_H := 720
const SIDEBAR_W := 180
const RIGHT_W := 110
const STRIP_X := SIDEBAR_W
const STRIP_W := VIEW_W - SIDEBAR_W - RIGHT_W

# Total height of the world strip. The view starts at the bottom.
const STRIP_H := 3600
const START_Y := STRIP_H - VIEW_H
# How far up from the start the view may go.
const MAX_SCROLL := 2000.0
# Pixels per second while a scroll button is held.
const SCROLL_SPEED := 1000.0
# World y the goal block must reach. A bit below the highest point of the view.
const GOAL_Y := START_Y - MAX_SCROLL + 100.0

const CELL := 64
const COLS := 14
const ROWS := 8
const GRID_BOTTOM_MARGIN := 40
# World position of the top left corner of the grid.
const GRID_ORIGIN := Vector2(
	STRIP_X + (STRIP_W - COLS * CELL) / 2.0,
	STRIP_H - ROWS * CELL - GRID_BOTTOM_MARGIN
)

const BACKGROUND := Color(0.07, 0.08, 0.11)

# Block types. The number is also the position in the colour list below.
const SOLID := 0
const THRUSTER := 1
const GOAL := 2
const BLOCK_COLORS: Array[Color] = [
	Color(0.50, 0.55, 0.62),
	Color(0.92, 0.52, 0.15),
	Color(0.19, 0.68, 0.40),
]

# Thruster directions in the order they cycle when R is pressed. The arrow
# on a thruster points the way it pushes the rocket.
const DIRECTIONS: Array[Vector2] = [
	Vector2(0, -1),
	Vector2(1, 0),
	Vector2(0, 1),
	Vector2(-1, 0),
]

# Physics tuning. Gravity is the project default, about 980 pixels per second
# squared, so one block weighs about 980 force units. Each thruster pushes with
# THRUST, so one thruster can lift roughly two and a half blocks.
const BLOCK_MASS := 1.0
const THRUST := 2500.0
const LINEAR_DAMP := 0.1
const ANGULAR_DAMP := 0.8
