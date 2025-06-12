extends Node

var slots: Array = []
var current_item: Node = null
var slots_count: int = 4

@onready var ray: RayCast3D = $"../RayCast3D"
@onready var hands: Node3D = $"../vision/hands"
@onready var inventory_container: HBoxContainer = $"../CanvasLayer/inventory_Container"
@onready var gui_slots: Array = []
@onready var warning_text: Label = $"../CanvasLayer/warning_text"

signal inventory_full

func _ready() -> void:
	for i in range(slots_count):
		slots.append(null)
		gui_slots.append(inventory_container.get_node('slot_%d' % (i+1)))

func _input(event: InputEvent) -> void:
	for i in range(slots_count):
		if event.is_action_pressed("slot_%d" % (i+1)):
			handle_slot_selection(i)

func handle_slot_selection(slot_index: int) -> void:
	if !slots[slot_index] && !hands.current_item:
		return
		
	hands.swap(slot_index, slots, gui_slots)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed('drop'):
		hands.drop_item(ray)
	
func inventory_append(item: Node3D):
	item.set_script(item.get_meta('use'))
	item.get_node('collision').disabled = true
	
	if !hands.current_item:
		hands.put_in_hands(item)
		return true
		
	for i in range(slots_count):
		if !slots[i]:
			slots[i] = item
			
			var label = gui_slots[i].get_node('Label') as Label
			label.text = slots[i].get_meta('name')
			
			return true
		
	inventory_full.emit()
	return false

func _on_inventory_full():
	warning_text.show_text('Inventory is full!')
	pass
