extends Control

var current_code: Array[int] = []
@onready var code_interface_layer: CanvasLayer = $".."
@onready var label: Label = $Panel/Label
@onready var static_body_3d: EnterPinCodeStrategy = $"../.."

func _ready() -> void:
	# Получаем всех детей BoxContainer (VBoxContainers)
	for column in $BoxContainer.get_children():
		for button in column.get_children():
			var name := button.name
			if name.begins_with("Button_"):
				var suffix := name.substr("Button_".length())
				if suffix.is_valid_int():
					button.pressed.connect(_on_number_button_pressed.bind(int(suffix)))
				elif suffix == "cancel":
					button.pressed.connect(_on_button_cancel_pressed)
				elif suffix == "accept":
					button.pressed.connect(_on_button_accept_pressed)

func _on_number_button_pressed(number: int) -> void:
	current_code.append(number)
	label.text = "".join(current_code.map(func(n): return str(n)))

	# print("Code so far:", current_code)

func _on_button_cancel_pressed() -> void:
	current_code.clear()
	label.text = ''
	code_interface_layer.hide()

func _on_button_accept_pressed() -> void:
	get_tree().call_group('win','check_code',current_code)
	current_code.clear()
	label.text = ''
	code_interface_layer.hide()
