extends Node

const crouch_height = 0.3
const normal_height = 1.0
const lowering = 0.01

var standing_height := 2.0
var current_height := standing_height

var ground_strength := 1.0
var air_strength := 0.2
var strength := 1.0

@onready var player: CharacterBody3D = $".."
@onready var collision: CollisionShape3D = $"../collision"
@onready var capsule_shape := collision.shape
@onready var ray_cast_3d: RayCast3D = $"../RayCast3D"
@onready var vision: Camera3D = $"../vision"

@onready var current_speed = normal_speed
@onready var world = get_tree().current_scene.get_node('nav_region/world')
@export var sense = 0.2
@export var normal_speed = 5.0
@export var sprint_speed = 8.0
@export var crouch_speed = 3.5
@export var jump_velocity = 4.5

func _ready() -> void:

	player.set_physics_process(true)

#region movement_stuff 
func can_stand_up() -> bool:
	var space_state = player.get_world_3d().direct_space_state
	var space_check = PhysicsRayQueryParameters3D.create(
		player.global_transform.origin,
		player.global_transform.origin + Vector3.UP * 1.0
	)
	space_check.collision_mask = 1  # по необходимости
	var result = space_state.intersect_ray(space_check)
	if not result:
		return true
	return result.empty()

	
func crouching(delta: float, target_speed: float, target_height: float, condition: bool):
	current_height = lerp(current_height, target_height, delta * 10)
	
	capsule_shape.height = current_height
	if player.is_on_floor() and condition:
		current_speed = lerp(current_speed, target_speed, delta * 10)
	
func movement_states(delta: float):
	var input_dir := Input.get_vector("a", "d", "w", "s")
	var direction := (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if not player.is_on_floor():
		strength = lerp(strength, air_strength, delta * 0.4)
		player.velocity.x = lerp(player.velocity.x, direction.x * current_speed, delta)
		player.velocity.z = lerp(player.velocity.z, direction.x * current_speed, delta)
	else:
		strength = ground_strength
	
	if Input.is_action_pressed("jump") and player.is_on_floor():
		player.velocity.y = jump_velocity
		
	if Input.is_action_pressed("crouch"):		
		crouching(delta, crouch_speed, crouch_height, current_speed > crouch_speed)
	else:
		crouching(delta, normal_speed, normal_height, current_speed < normal_speed)
	
	if not Input.is_action_pressed("crouch"):
		current_speed = lerp(current_speed, normal_speed, delta * 5)
		
	if Input.is_action_pressed("sprint") and not Input.is_action_pressed("crouch"):
		current_speed = lerp(current_speed, sprint_speed, delta * 5)
		
	if direction:
		player.velocity.x = direction.x * current_speed * strength
		player.velocity.z = direction.z * current_speed * strength
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, current_speed)
		player.velocity.z = move_toward(player.velocity.z, 0, current_speed)
#region 

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var rotating_vision = vision.rotation.x - event.relative.y * lowering * sense
		
		vision.rotation.x = clamp(rotating_vision, -1.5, 1.5)
		ray_cast_3d.rotation.x = 1.570796 + vision.rotation.x
		
		player.rotation.y -= event.relative.x * lowering * sense

func _physics_process(delta: float) -> void:
	movement_states(delta)
