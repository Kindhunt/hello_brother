class_name PickupStrategy
extends InteractionStrategy

func interact(_interactor: Node) -> void:
	var result = _interactor.get_node('inventory_system').inventory_append(duplicate())
	if result:
		queue_free()
