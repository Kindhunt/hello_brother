extends NavigationRegion3D

@onready var target: CharacterBody3D = $world_root/player
var last_player_pos: Vector3

enum states {AGR,IDL}

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if target.global_position.distance_to(last_player_pos) > 0.5:
		last_player_pos = target.global_position
		get_tree().call_group("brother", "target_position", target.global_position)
