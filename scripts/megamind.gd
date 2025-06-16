extends CharacterBody3D

@export var movement_speed: float = 3.0
@export var lost_player_chase_duration: float = 5.0
@export var wait_time_at_point_min: float = 3.0
@export var wait_time_at_point_max: float = 8.0

@onready var chase_agent: NavigationAgent3D = $chase_agent
@onready var vision: RayCast3D = $vision
@onready var wait_timer: Timer = $wait_timer
@onready var lost_player_timer: Timer = $lost_player_timer

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var player: CharacterBody3D = null
var bunch_of_points: Array[Node3D] = [] 

enum State { CHASE, SEARCH, IDLE }
var current_state: State = State.IDLE

func _ready() -> void:
	chase_agent.velocity_computed.connect(Callable(_on_velocity_computed))
	chase_agent.path_desired_distance = 1.0
	chase_agent.target_desired_distance = 0.5
	chase_agent.avoidance_enabled = true

	wait_timer.wait_time = rng.randf_range(wait_time_at_point_min, wait_time_at_point_max)
	wait_timer.one_shot = true
	lost_player_timer.wait_time = lost_player_chase_duration
	lost_player_timer.one_shot = true

	player = get_tree().current_scene.get_node('world_root/player')
	var points := get_tree().current_scene.get_node('world_root/NavigationRegion3D/points').get_children()
	for point in points:
		bunch_of_points.append(point as Node3D)

	wait_timer.timeout.connect(_on_wait_timer_timeout)
	lost_player_timer.timeout.connect(_on_lost_player_timeout)

	go_to_random_point()

func has_reached_point(target_position: Vector3, threshold: float = 0.5) -> bool:
	var distance_2d = Vector2(global_position.x, global_position.z).distance_to(Vector2(target_position.x, target_position.z))
	return distance_2d <= threshold


@warning_ignore("unused_variable")
func _physics_process(delta):
	vision.look_at(player.global_position)
	vision.rotation.x += 1.570796
	
	var can_see_player := vision.get_collider() == player

	match current_state:
		State.CHASE:
			if can_see_player:
				chase_agent.set_target_position(player.global_position)
				lost_player_timer.start()
			elif not lost_player_timer.is_stopped() and not can_see_player:
				chase_agent.set_target_position(player.global_position)
			else:
				go_to_random_point()

		State.SEARCH, State.IDLE:
			if can_see_player:
				current_state = State.CHASE
				chase_agent.set_target_position(player.global_position)
				lost_player_timer.start()

	if NavigationServer3D.map_get_iteration_id(chase_agent.get_navigation_map()) == 0:
		return
	var next_path_position: Vector3 = chase_agent.get_next_path_position()
	if has_reached_point(next_path_position):
		if current_state == State.SEARCH:
			current_state = State.IDLE
			wait_timer.start()
		return
	var new_velocity: Vector3 = (next_path_position - global_position).normalized() * movement_speed
	if chase_agent.avoidance_enabled:
		chase_agent.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)

func _on_velocity_computed(safe_velocity: Vector3):
	velocity = safe_velocity
	move_and_slide()

func go_to_random_point():
	current_state = State.SEARCH
	var point = bunch_of_points.pick_random()
	while point.global_position == chase_agent.target_position:
		point = bunch_of_points.pick_random()
	wait_timer.wait_time = rng.randf_range(wait_time_at_point_min, wait_time_at_point_max)
	chase_agent.set_target_position(point.global_position)

func _on_wait_timer_timeout():
	go_to_random_point()

func _on_lost_player_timeout():
	go_to_random_point()

func _on_navigation_finished():
	if current_state == State.SEARCH:
		current_state = State.IDLE
		wait_timer.start()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body == player:
		call_deferred("_change_to_lose_screen")

func _change_to_lose_screen() -> void:
	get_tree().change_scene_to_file("res://scenes/controls/lose_screen.tscn")
