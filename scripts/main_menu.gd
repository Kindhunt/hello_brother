extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_exit_button_down() -> void:
	# TO-DO: Save logic
	get_tree().quit()

func _on_settings_button_down() -> void:
	# TO-DO: Make settings menu
	pass
	
func _on_load_save_button_down() -> void:
	pass # Replace with function body.

func _on_start_new_game_button_down() -> void:
	# TO-DO: Start new game logic, like, just from very beggining, not special and complex one
	pass
