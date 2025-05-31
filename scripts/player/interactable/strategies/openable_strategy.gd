class_name OpenableStrategy
extends InteractionStrategy

var is_opened = false

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var collision: CollisionShape3D = $collision

func interact(_interactor: Node) -> void:
	is_opened = !is_opened
	
	if is_opened:
		animation_player.play('open')
	else:
		animation_player.play('close')

func _process(delta: float) -> void:
	is_busy = animation_player.is_playing()
