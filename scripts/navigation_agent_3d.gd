extends NavigationAgent3D

func _ready() -> void:
	var agent: RID = get_rid()
	NavigationServer3D.agent_set_avoidance_enabled(agent, true)
	NavigationServer3D.agent_set_avoidance_callback(agent, Callable(self, "_avoidance_done"))
	NavigationServer3D.agent_set_use_3d_avoidance(agent, true)

func _on_velocity_computed(new_velocity: Vector3) -> void:
	self.velocity = new_velocity
	self.get_parent().velocity = new_velocity
