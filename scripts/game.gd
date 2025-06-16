extends Node

signal visible_changed
signal settings_changed(sense, invert_x, invert_y)

var sense: int
var invert_x: bool
var invert_y: bool
var is_input: bool

@onready var in_game_controls: Control = $CanvasLayer/in_game_controls
@onready var interaction_gui_layer: CanvasLayer = $world_root/player/CanvasLayer

const DEFAULT_BUS_LAYOUT = preload("res://resources/default_bus_layout.tres")

func _ready() -> void:
	AudioServer.set_bus_layout(DEFAULT_BUS_LAYOUT)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float) -> void:
	var tree = get_tree()
	if Input.is_action_just_pressed("menu"):
		var is_paused = !tree.paused
		tree.paused = is_paused
		
		in_game_controls.visible = is_paused
			
		if tree.paused:
			interaction_gui_layer.hide()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			interaction_gui_layer.show()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			visible_changed.emit()
	
func update_invert_x(toggled_on: bool):
	invert_x = toggled_on
	emit_signal('settings_changed',sense,invert_x,invert_y)

func update_invert_y(toggled_on: bool):
	invert_y = toggled_on
	emit_signal('settings_changed',sense,invert_x,invert_y)

func update_sense(value: float):
	sense = value
	emit_signal('settings_changed',sense,invert_x,invert_y)
