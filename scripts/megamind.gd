extends CharacterBody3D

@export var movement_speed: float = 3.0
@onready var chase_agent: NavigationAgent3D = $chase_agent
@onready var vision: RayCast3D = $vision
@onready var player: 
	
func _ready() -> void:
	chase_agent.velocity_computed.connect(Callable(_on_velocity_computed))

	chase_agent.path_desired_distance = 1.0
	chase_agent.target_desired_distance = 0.5
	chase_agent.avoidance_enabled = true

func target_position(movement_target: Vector3):
	chase_agent.set_target_position(movement_target)

func _physics_process(delta):	
	vision.look_at()
	if NavigationServer3D.map_get_iteration_id(chase_agent.get_navigation_map()) == 0:
		return
	if chase_agent.is_navigation_finished():
		return

	var next_path_position: Vector3 = chase_agent.get_next_path_position()
	var new_velocity: Vector3 = (next_path_position - global_position).normalized() * movement_speed
	if chase_agent.avoidance_enabled:
		chase_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector3):
	velocity = safe_velocity
	move_and_slide()
