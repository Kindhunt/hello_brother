class_name DoorStrategy
extends InteractionStrategy

var is_opened = false

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

func interact(_interactor: Node) -> void:
	is_opened = !is_opened
	
	if is_opened:
		animation_player.play('open')
	else:
		animation_player.play('close')
