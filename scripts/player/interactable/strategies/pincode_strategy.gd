class_name EnterPinCodeStrategy
extends InteractionStrategy

@onready var canvas_layer: CanvasLayer = $CanvasLayer

func interact(_interactor: Node) -> void:
	canvas_layer.show()


func _on_canvas_layer_visibility_changed() -> void:
	await get_tree().process_frame
	if canvas_layer.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().paused = true
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_tree().paused = false
