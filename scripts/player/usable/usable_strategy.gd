class_name UsableStrategy
extends RigidBody3D

func _ready() -> void:
	set_deferred("freeze", true)

func use(target: Node3D = null, coords: Vector3 = Vector3.ZERO) -> void:
	push_error('Not implemented')
