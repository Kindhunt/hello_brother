class_name WinStrategy
extends InteractionStrategy

@export var code: Array[int] = [0,0,0,0]

var is_unlocked_key: bool = false
var is_unlocked_code: bool = false
var is_unlocked_hammer: bool = false

@onready var plank: StaticBody3D = $"../plank"
@onready var plank_2: StaticBody3D = $"../plank2"
@onready var win_door: Node3D = $".."

@onready var label: Label = $"../CanvasLayer/message/Label"
@onready var canvas_layer: CanvasLayer = $"../CanvasLayer"
@export var disappear_time: float = 2.0

var timer: Timer

func _ready() -> void:
	canvas_layer.hide()
	setup_timer()

func setup_timer() -> void:
	timer = Timer.new()
	timer.wait_time = disappear_time
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

func interact(_interactor: Node) -> void:
	if is_unlocked_code and is_unlocked_hammer and is_unlocked_key:
		call_deferred('_change_to_win_screen')
	else:
		show_message()
	
func _change_to_win_screen() -> void:
	get_tree().change_scene_to_file("res://scenes/controls/win_screen.tscn")

func show_message():
	canvas_layer.show()
	label.text = 'you need to find:\n'
	if not is_unlocked_key:
		label.text += 'key\n'
	if not is_unlocked_code:
		label.text += 'code\n'
	if not is_unlocked_hammer:
		label.text += 'hammer\n'
	timer.start()

func show_error_message():
	canvas_layer.show()
	label.text = 'incorrect code'
	timer.start()

func check_key():
	is_unlocked_key = true
	if not is_unlocked_code or not is_unlocked_hammer:
		show_message()

func check_hammer():
	if win_door.get_child_count() < 5:
		is_unlocked_hammer = true
		if not is_unlocked_code or not is_unlocked_key:
			show_message()

func check_code(entered_code: Array[int]):
	if entered_code.size() != code.size():
		show_error_message()
	else:
		for i in range(code.size()):
			if entered_code[i] != code[i]:
				show_error_message()
				return
		is_unlocked_code = true
		if not is_unlocked_key or not is_unlocked_key:
			show_message()

func _on_timer_timeout() -> void:
	canvas_layer.hide()
