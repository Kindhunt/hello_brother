extends Node

const crouch_height = 0.3
const normal_height = 1.0
const lowering = 0.001

var standing_height := 2.0
var current_height := standing_height

var ground_strength := 1.0
var air_strength := 0.2
var strength := 1.0

var mouse_sensitivity = 1
var invert_x = false
var invert_y = false
var head_bob_timer := 0.0
var head_bob_amount := 0.08
var head_bob_speed := 8.0
var default_camera_offset := Vector3.ZERO
var head_bob_speed_mod := 0.0
var bob_intensity := 0.0

@onready var flashlight: SpotLight3D = $"../vision/hands/flashlight"
@onready var player: CharacterBody3D = $".."
@onready var collision: CollisionShape3D = $"../collision"
@onready var capsule_shape := collision.shape
@onready var ray_cast_3d: RayCast3D = $"../RayCast3D"
@onready var vision: Camera3D = $"../vision"

@onready var current_speed = normal_speed
@onready var world = get_tree().current_scene.get_node('world_root/world')
@export var normal_speed = 5.0
@export var sprint_speed = 8.0
@export var crouch_speed = 3.5
@export var jump_velocity = 4.5

@onready var root = get_tree().get_first_node_in_group("root")

func _ready() -> void:
	default_camera_offset = vision.position
	if root:
		root.settings_changed.connect(_on_settings_changed)
	player.set_physics_process(true)

func _on_settings_changed(sense, invert_x, invert_y):
	mouse_sensitivity = sense
	self.invert_x = invert_x
	self.invert_y = invert_y

func apply_head_bob(delta: float):
	var input_dir := Input.get_vector("a", "d", "w", "s")
	var is_moving := input_dir.length() > 0.1 and player.is_on_floor()

	if is_moving:
		head_bob_timer += delta * head_bob_speed

		var target_bob = 1.3 if Input.is_action_pressed("sprint") else 0.9
		bob_intensity = lerp(bob_intensity, target_bob, delta * 4.0)

		var bob_x = sin(head_bob_timer * 1.0) * head_bob_amount * 0.5 * bob_intensity
		var bob_y = sin(head_bob_timer * 2.0) * head_bob_amount * 1.0 * bob_intensity
		vision.position = default_camera_offset + Vector3(bob_x, bob_y, 0)
	else:
		head_bob_timer = 0.0
		bob_intensity = lerp(bob_intensity, 0.0, delta * 6.0)
		vision.position = vision.position.lerp(default_camera_offset, delta * 5.0)


#region movement_stuff 
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

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("flashlight"):
		flashlight.visible = !flashlight.visible

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var rotating_vision = 0
		
		if invert_y:
			rotating_vision = vision.rotation.x - event.relative.y \
			* lowering * mouse_sensitivity * -1
		else:
			rotating_vision = vision.rotation.x - event.relative.y \
			* lowering * mouse_sensitivity
		vision.rotation.x = clamp(rotating_vision, -1.5, 1.5) 
		ray_cast_3d.rotation.x = 1.570796 + vision.rotation.x
		
		if invert_x:
			player.rotation.y += event.relative.x * lowering * mouse_sensitivity
		else:
			player.rotation.y -= event.relative.x * lowering * mouse_sensitivity 

func _physics_process(delta: float) -> void:
	movement_states(delta)
	apply_head_bob(delta)
