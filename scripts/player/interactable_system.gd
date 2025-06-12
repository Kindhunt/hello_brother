extends Node

@onready var ray_cast_3d: RayCast3D = $"../RayCast3D"
@onready var interact_text: Label = $"../CanvasLayer/BoxContainer/interact_text"
@onready var player: CharacterBody3D = $".."
@onready var hands: Node3D = $"../vision/hands"

func _ready() -> void:
	interact_text.hide()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("use"):
		var usable = hands.get_child(hands.get_child_count() - 1)
		if usable.has_method("use") and not usable.get_meta('is_pair'):
			usable.use()

func _physics_process(delta: float) -> void:
	if interact_text.visible:
		interact_text.hide()
	
	if ray_cast_3d.is_colliding():
		var target = ray_cast_3d.get_collider()
		if target != null && target.get_meta_list().size() > 0:
			if target.has_method("interact") and not target.is_busy:
				interact_text.show()
				if Input.is_action_just_pressed('interact'):
					target.interact(player)
			
	pass
