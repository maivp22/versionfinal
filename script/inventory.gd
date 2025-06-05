extends Resource

class_name Inventory

signal updated

@export var slots: Array[InventorySlot]


signal started_collecting

var has_started_collecting := false

func insert(item: InventoryItem):
	var itemSlots = slots.filter(func(slot): return slot.item == item)
	if !itemSlots.is_empty():
		itemSlots[0].amount += 1
	else:
		var emptySlots = slots.filter(func(slot): return slot.item == null)
		if !emptySlots.is_empty():
			emptySlots[0].item = item
			emptySlots[0].amount = 1

	if !has_started_collecting:
		has_started_collecting = true
		started_collecting.emit()

	print("insertando ", item.name)
	updated.emit()

	if get_total_items() >= 40:
		print("🎉 ¡Recolectaste 40 objetos!")
		# aquí va el cambio de escena a la estatua 1
	
func removeSlot(inventorySlot: InventorySlot):
	var index = slots.find(inventorySlot)
	if index < 0 : return
	
	remove_at_index(index)

func remove_at_index(index: int):
	slots[index] = InventorySlot.new()
	updated.emit()

func insertSlot(index: int, inventorySlot: InventorySlot):
	slots[index] = inventorySlot
	updated.emit()
	
func get_total_items() -> int:
	var total := 0
	for slot in slots:
		if slot.item != null:
			total += slot.amount
	return total
