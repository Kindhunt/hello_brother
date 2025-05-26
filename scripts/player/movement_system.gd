extends Node

const crouch_height = 0.5
const normal_height = 1.0
const lowering = 0.01

@onready var player: CharacterBody3D = $".."
@onready var collision: CollisionShape3D = $"../collision"
@onready var ray_cast_3d: RayCast3D = $"../RayCast3D"
@onready var vision: Camera3D = $"../vision"

@onready var current_speed = normal_speed

@export var sense = 0.2
@export var normal_speed = 5.0
@export var sprint_speed = 8.0
@export var crouch_speed = 3.5
@export var jump_velocity = 4.5

#region movement_stuff 
func crouching(delta: float, speed: float, scale: float, condition: bool):
	if collision.scale.y != scale:
		collision.scale.y = lerp(collision.scale.y, scale, delta * 10)
	if player.is_on_floor() and condition:
		current_speed = lerp(current_speed, speed, delta * 10)
	
func movement_states(delta: float):
	var input_dir := Input.get_vector("a", "d", "w", "s")
	var direction := (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta
		player.velocity.x = lerp(player.velocity.x, direction.x * current_speed, delta)
		player.velocity.z = lerp(player.velocity.z, direction.x * current_speed, delta)
	
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
		player.velocity.x = direction.x * current_speed
		player.velocity.z = direction.z * current_speed
		
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
	
	player.move_and_slide()
