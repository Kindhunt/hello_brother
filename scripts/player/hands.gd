extends Node3D

@onready var drop_obj: Node3D = $"../drop_obj"
@onready var alligner: Node3D = $"../../alligner"

const path_to_world := 'world_root/world'

var current_item: Node3D = null

func check_on_player(origin: Vector3) -> Variant:
	var space = get_world_3d().direct_space_state

	var query = PhysicsShapeQueryParameters3D.new()
	
	query.set_shape(current_item.get_node('collision').shape)
	query.transform.origin = origin
	query.collide_with_bodies = true

	var results = space.intersect_shape(query)
	for result in results:
		if result.collider is CharacterBody3D:
			return Vector3(0, result.collider.global_rotation.y, 0)
	return null
	
func align_item(item: Node3D, direction := Vector3.DOWN, max_distance := 3.0) -> void:
	var rot = check_on_player(item.global_position)
	
	if rot:
		item.global_position = alligner.global_position
	
	var from = item.global_position
	var to = from + direction.normalized() * max_distance

	var space = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.exclude = [item]

	var result = space.intersect_ray(query)

	if result:  
		var hit_pos = result.position
		var offset = from - hit_pos
		item.global_position -= offset


func drop_item(ray: RayCast3D) -> void:
	var spawned_item: Node3D = null
	if !current_item:
		return
	
	var drop_pos: Vector3
	
	if ray.is_colliding():
		drop_pos = ray.get_collision_point()
	else:
		drop_pos = drop_obj.global_position 
		
	current_item.scale = current_item.get_meta("current_scale")
	
	spawned_item = current_item.duplicate() as RigidBody3D
	current_item.queue_free()
	
	spawned_item.freeze = false
	
	var item_mesh_instance = spawned_item.get_node('mesh')
	item_mesh_instance.cast_shadow = true
	
	spawned_item.set_script(current_item.get_meta('pickup'))
	spawned_item.get_node('collision').disabled = false
	
	get_tree().current_scene.get_node(path_to_world).add_child(spawned_item)
		
	spawned_item.global_position = drop_pos
	
	align_item(spawned_item)

	spawned_item.linear_velocity = Vector3.ZERO
	spawned_item.angular_velocity = Vector3.ZERO
	
	spawned_item.sleeping = false
	
	spawned_item.rotation = Vector3(0, drop_obj.global_rotation.y, 0)


func reset_item() -> void:
	
	current_item.scale = current_item.get_meta('in_hand_scale')
	current_item.position = Vector3.ZERO
	current_item.rotation = Vector3.ZERO
	

	add_child(current_item)

func put_in_hands(item: Node3D) -> void:
	current_item = item.duplicate()
	
	var item_mesh_instance = current_item.get_node('mesh') as MeshInstance3D
	item_mesh_instance.cast_shadow = false	
	item.queue_free()	
	reset_item()

func swap(slot_index: int, slots: Array, gui_slots: Array) -> void:
	var current_name: String = ''
	
	if current_item != null:
		current_name = current_item.get_meta('name')
	
	var label: Label = gui_slots[slot_index].get_node('Label') as Label
	
	var current_item_node: Node3D = null
	if current_item != null:
		current_item_node = current_item.duplicate() 
		current_item.queue_free()
		
	var slot_item_node: Node3D = null
	if slots[slot_index]:
		slot_item_node = slots[slot_index].duplicate() 
		slots[slot_index].queue_free()
	
	if get_child(get_child_count() - 1) is RigidBody3D:
		remove_child(current_item)
		
	slots[slot_index] = current_item_node
	current_item = slot_item_node
	
	if current_item:
		reset_item()
		
	label.text = current_name
	
