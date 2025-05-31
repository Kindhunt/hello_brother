extends Node

@onready var ray_cast_3d: RayCast3D = $"../RayCast3D"
@onready var interact_text: Label = $"../CanvasLayer/BoxContainer/interact_text"
@onready var player: CharacterBody3D = $".."

func _ready() -> void:
	interact_text.hide()

func _physics_process(delta: float) -> void:
	if interact_text.visible:
		interact_text.hide()
	
	if ray_cast_3d.is_colliding():
		var target = ray_cast_3d.get_collider()
		if target != null && target.get_meta_list().size() > 0:
			if target.get_meta('interactable') and not target.is_busy:
				interact_text.show()
				if Input.is_action_just_pressed('interact'):
					target.interact(player)
	pass
