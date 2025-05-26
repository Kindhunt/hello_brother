extends Control

@export var menu_box: Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_back_button_down() -> void:
	visible = false
	menu_box.visible = true
