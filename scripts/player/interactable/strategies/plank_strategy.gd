class_name PlankStrategy
extends InteractionStrategy

@onready var collision: CollisionShape3D = $collision

func interact(_interactor: Node) -> void:
	if _interactor is HammerStrategy:
		queue_free()
		get_tree().call_group("win","check_hammer")
