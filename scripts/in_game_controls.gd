extends Control

@onready var settings_menu: Control = $settings_menu
@onready var menu_box: VBoxContainer = $menu_box

func _ready() -> void:
	visible = false
	
func _process(delta: float) -> void:
	pass
	
func _on_continue_game_button_down() -> void:
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	visible = false
	
func _on_load_save_button_down() -> void:
	pass
	
func _on_settings_button_down() -> void:
	menu_box.visible = false
	settings_menu.visible = true
	
func _on_exit_button_down() -> void:
	pass
	
func _on_game_visible_changed() -> void:
	menu_box.visible = true
	settings_menu.visible = false
