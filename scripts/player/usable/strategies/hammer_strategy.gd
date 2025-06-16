class_name HammerStrategy
extends UsableStrategy

func use(target: Node3D = null, coords: Vector3 = Vector3.ZERO) -> void:
	if target.is_in_group('plank'):
		target.interact(self)
