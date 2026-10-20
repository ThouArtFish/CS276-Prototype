class_name Sidebar
extends Panel
# Left panel with the block swatches, the erase toggle and the clear button.

signal block_picked(block_type: int)
signal erase_toggled(on: bool)
signal clear_pressed

# Locked while a run is in progress.
var locked := false
var erase_on := false

@onready var swatches: Control = $Column/Swatches
@onready var erase_button: Button = $Column/EraseButton
@onready var clear_button: Button = $Column/ClearButton


func _ready() -> void:
	for child in swatches.get_children():
		(child as BlockSwatch).picked.connect(_on_swatch_picked)
	erase_button.toggled.connect(_on_erase_button_toggled)
	clear_button.pressed.connect(func() -> void: clear_pressed.emit())


func set_locked(on: bool) -> void:
	locked = on
	erase_button.disabled = on
	clear_button.disabled = on
	_refresh_swatches()


# Shows the current thruster direction on the thruster swatch.
func set_thruster_direction(dir: int) -> void:
	for child in swatches.get_children():
		var swatch := child as BlockSwatch
		if swatch.block_type == Config.THRUSTER:
			swatch.set_direction(dir)


func _refresh_swatches() -> void:
	for child in swatches.get_children():
		(child as BlockSwatch).set_enabled(not erase_on and not locked)


func _on_swatch_picked(block_type: int) -> void:
	block_picked.emit(block_type)


func _on_erase_button_toggled(on: bool) -> void:
	erase_on = on
	erase_button.text = "Erase: ON" if on else "Erase: OFF"
	_refresh_swatches()
	erase_toggled.emit(on)
