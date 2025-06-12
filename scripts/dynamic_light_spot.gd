extends SpotLight3D

@onready var flashlight_sound_on: AudioStreamPlayer = $"../flashlight_sound_on"
@onready var flashlight_sound_off: AudioStreamPlayer = $"../flashlight_sound_off"

func _ready() -> void:
	shadow_enabled = true
	spot_angle = 45
	spot_angle_attenuation = 1.0


func _on_visibility_changed() -> void:
	if visible:
		flashlight_sound_on.play()
	else:
		flashlight_sound_off.play()
