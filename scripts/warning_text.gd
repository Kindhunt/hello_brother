extends Label

@export var disappear_time: float = 2.0  # Время в секундах до исчезновения
var timer: Timer

func _ready() -> void:
	hide()
	setup_timer()

func setup_timer() -> void:
	timer = Timer.new()
	timer.wait_time = disappear_time
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

func show_text(_text: String) -> void:
	self.text = _text
	show()
	timer.start()

func _on_timer_timeout() -> void:
	hide()
