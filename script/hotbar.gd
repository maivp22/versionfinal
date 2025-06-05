extends Panel

@onready var inventory: Inventory = preload("res://inventory/playerInventory.tres")
@onready var slots: Array = $Container.get_children()
@onready var selector: Sprite2D = $Selector

var currently_selected: int = 0

func _ready() -> void:
	update()
	inventory.updated.connect(update)

func update():
	for i in range(slots.size()):
		var inventory_slot: InventorySlot = inventory.slots[i]
		slots[i].update_to_slot(inventory_slot)

func move_selector():
	currently_selected = (currently_selected + 1) % slots.size()
	selector.global_position = slots[currently_selected].global_position

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_selector"):
		move_selector()
