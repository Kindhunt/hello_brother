class_name UsableStrategy
extends RigidBody3D

func _ready() -> void:
	set_deferred("freeze", true)

func use(ray_cast: RayCast3D, coords: Vector3) -> void:
	push_error('Not implemented')
