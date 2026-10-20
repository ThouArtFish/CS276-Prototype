class_name RightPanel
extends Panel
# Right panel with the scroll buttons, the height readout and the run buttons.

signal up_held_changed(held: bool)
signal down_held_changed(held: bool)
signal start_pressed
signal reset_pressed

@onready var height_label: Label = $Column/HeightLabel
@onready var up_button: Button = $Column/UpButton
@onready var down_button: Button = $Column/DownButton
@onready var start_button: Button = $Column/StartButton
@onready var reset_button: Button = $Column/ResetButton


func _ready() -> void:
	up_button.button_down.connect(func() -> void: up_held_changed.emit(true))
	up_button.button_up.connect(func() -> void: up_held_changed.emit(false))
	down_button.button_down.connect(func() -> void: down_held_changed.emit(true))
	down_button.button_up.connect(func() -> void: down_held_changed.emit(false))
	start_button.pressed.connect(func() -> void: start_pressed.emit())
	reset_button.pressed.connect(func() -> void: reset_pressed.emit())
	set_running(false)


func set_height(height: float) -> void:
	height_label.text = "HEIGHT\n%d / %d" % [roundi(height), int(Config.MAX_SCROLL)]


# The reset button only shows during a run, under the start button.
func set_running(on: bool) -> void:
	start_button.disabled = on
	reset_button.visible = on
