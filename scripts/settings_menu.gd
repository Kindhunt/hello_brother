extends Control

@export var menu_box: Control
@export var database: Node

@onready var screen_resolution_option: OptionButton = $settings_container/graphics/screen_resolution_Container/screen_resolution_Option
@onready var fps_limit_slider: HSlider = $settings_container/graphics/fps_limit_Container/fps_limit_Slider
@onready var shadow_quality: OptionButton = $settings_container/graphics/shadow_quality_Container/shadow_quality
@onready var anti_aliasing: OptionButton = $settings_container/graphics/anti_aliasing_Container/anti_aliasing
@onready var master_sound_slider: HSlider = $settings_container/sound/master_sound_Container/master_sound_Slider
@onready var music_slider: HSlider = $settings_container/sound/music_Container/music_Slider
@onready var sfx_slider: HSlider = $settings_container/sound/sfx_Container/sfx_Slider
@onready var sense: HSlider = $settings_container/controls/sense_Container/sense
@onready var invert_mouse_x: CheckButton = $settings_container/controls/invert_mouse_Container/invert_mouse_x
@onready var invert_mouse_y: CheckButton = $settings_container/controls/invert_mouse_Container/invert_mouse_y

var is_loading = false
var temp_settings := {}

var resolutions = [
	Vector2i(1280, 720),
	Vector2i(1920, 1080),
	Vector2i(2560, 1440),
	Vector2i(3840, 2160),
]

var aliasing_q = [
	Viewport.MSAA_DISABLED,
	Viewport.MSAA_2X,
	Viewport.MSAA_4X,
	Viewport.MSAA_8X
]

func _ready() -> void:

	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

	visible = false

	database.load_db()
	load_settings()

func load_settings():
	is_loading = true
	temp_settings = database.dictionary_db.duplicate(true)

	screen_resolution_option.select(temp_settings['resolution'])
	fps_limit_slider.value = temp_settings['fps']
	shadow_quality.select(temp_settings['shadow'])
	anti_aliasing.select(temp_settings['antialiasing'])
	master_sound_slider.value = temp_settings['master']
	music_slider.value = temp_settings['music']
	sfx_slider.value = temp_settings['sfx']
	sense.value = temp_settings['sense']
	invert_mouse_x.button_pressed = bool(temp_settings['invert_x'])
	invert_mouse_y.button_pressed = bool(temp_settings['invert_y'])

	is_loading = false

func _on_back_button_down() -> void:
	visible = false
	menu_box.visible = true

# UI Handlers — только обновление temp_settings

func _on_screen_resolution_option_item_selected(index: int) -> void:
	if is_loading: return
	temp_settings['resolution'] = index

func _on_fps_limit_slider_value_changed(value: float) -> void:
	if is_loading: return
	temp_settings['fps'] = floor(value)

func _on_shadow_quality_item_selected(index: int) -> void:
	if is_loading: return
	temp_settings['shadow'] = index

func _on_anti_aliasing_item_selected(index: int) -> void:
	if is_loading: return
	temp_settings['antialiasing'] = index

func _on_master_sound_slider_value_changed(value: float) -> void:
	if is_loading: return
	temp_settings['master'] = floor(value)

func _on_music_slider_value_changed(value: float) -> void:
	if is_loading: return
	temp_settings['music'] = floor(value)

func _on_sfx_slider_value_changed(value: float) -> void:
	if is_loading: return
	temp_settings['sfx'] = floor(value)

func _on_sense_value_changed(value: float) -> void:
	if is_loading: return
	temp_settings['sense'] = floor(value)

func _on_invert_mouse_x_toggled(toggled_on: bool) -> void:
	if is_loading: return
	temp_settings['invert_x'] = int(toggled_on)

func _on_invert_mouse_y_toggled(toggled_on: bool) -> void:
	if is_loading: return
	temp_settings['invert_y'] = int(toggled_on)

# Применение изменений

func apply_settings() -> void:
	for key in temp_settings.keys():
		database.update_value(key, temp_settings[key])

	# Apply sound
	var db = linear_to_db(temp_settings['master'] / 100.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db)

	db = linear_to_db(temp_settings['music'] / 100.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), db)

	db = linear_to_db(temp_settings['sfx'] / 100.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), db)

	# Controls
	get_tree().call_group("root", "update_sense", temp_settings['sense'])
	get_tree().call_group("root", "update_invert_x", bool(temp_settings['invert_x']))
	get_tree().call_group("root", "update_invert_y", bool(temp_settings['invert_y']))

	# Graphics
	DisplayServer.window_set_size(resolutions[temp_settings['resolution']])
	Engine.max_fps = temp_settings['fps']
	get_viewport().msaa_3d = aliasing_q[temp_settings['antialiasing']]


func _on_hidden() -> void:
	call_deferred("apply_settings")
