extends Node

var slots: Array = []
var current_item: Node = null

@onready var hands: Node3D = $"../hands"
@onready var inventory_container: HBoxContainer = $"../CanvasLayer/inventory_Container"
@onready var gui_slots: Array = []
@onready var warning_text: Label = $"../CanvasLayer/warning_text"

signal inventory_full

func _ready() -> void:
	gui_slots.append(inventory_container.get_node('slot_1'))
	gui_slots.append(inventory_container.get_node('slot_2'))
	gui_slots.append(inventory_container.get_node('slot_3'))
	gui_slots.append(inventory_container.get_node('slot_4'))

func _input(event: InputEvent) -> void:
	for i in range(4):
		if event.is_action_pressed("slot_%d" % (i+1)):
			handle_slot_selection(i)

func handle_slot_selection(slot_index: int) -> void:
	if slots[slot_index].is_empty():
		return
	pass

func _process(delta: float) -> void:
	if Input.is_action_just_pressed('drop'):
		pass
	pass

func inventory_append(item: Node3D):
	if slots.size() < 4:
		slots.append(item)
		for i in slots.size():
			var label = gui_slots[i].get_node('Label') as Label
			label.text = slots[i].get_meta('name')
		return true
	inventory_full.emit()
	return false


func _on_inventory_full():
	warning_text.show_text('Inventory is full!')
	pass
