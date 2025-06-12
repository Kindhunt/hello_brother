extends Node

signal visible_changed

#create signal for auto_save

@onready var in_game_controls: Control = $CanvasLayer/in_game_controls
@onready var database: Node = $database
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
	
