extends Control

@export var menu_box: Control

func _ready() -> void:
	visible = false


func _on_back_button_down() -> void:
	visible = false
	menu_box.visible = true
