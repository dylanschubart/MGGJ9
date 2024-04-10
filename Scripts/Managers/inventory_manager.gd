extends Node

var item_list: Array[ItemData] = []

func set_inventory():

	Ui.inventory_list.clear()
	item_list.clear()
	var items_nodes = Ui.inventory_items.get_children()
	
	for node in items_nodes:
		item_list.append(node.item_data)
		Ui.inventory_list.add_item(node.item_data.item_name, null, true)

	Ui.save.inventory.items = item_list
	Ui.save.save_game()
	return item_list

func add_item(item_data: ItemData):
	var inventory_item_node = Ui.inventory_items
	var item_scene = load(item_data.scene_path)
	var instantiated_item = item_scene.instantiate()
	instantiated_item.item_data = item_data
	instantiated_item.item_data.item_in_inventory = true
	instantiated_item.item_data.item_equiped = false
	inventory_item_node.add_child(instantiated_item)
	set_inventory()
	
func remove_item_from_inventory(index: int):
	var inventory_items = Ui.inventory_items.get_children()
	var item = inventory_items[index]

	item.remove_from_group("inventory")
	print_debug("Removed from inventory: %s" % item)
	item.queue_free()
	await item.tree_exited
	Ui.inventory_list.remove_item(index)
	set_inventory()
	
func examine_item(index):
	var type = item_list[index].ITEM_TYPES.find_key(item_list[index].item_type)
	LogManager.write_to_log("Item type: " + type)
	LogManager.write_to_log(item_list[index].item_examine_text)

func use_equip(index: int):
	var inventory_items = Ui.inventory_items.get_children()
	var equiped_items = Ui.save.equipment.equipedItems
	var item = inventory_items[index]

	if item.item_data.item_equipable:
		var equiped_item_to_remove;
		for equiped_item in equiped_items:
			if equiped_item.item_type == item.item_data.item_type:
				equiped_item_to_remove = equiped_item 
		if equiped_item_to_remove != null:		
			add_item(equiped_item_to_remove)
			EquipmentManager.remove_item_from_equipment(equiped_items.find(equiped_item_to_remove))

		EquipmentManager.add_item(item.item_data)
		remove_item_from_inventory(index)
	else:
		return

func load_inventory():
	for item in Ui.save.inventory.items:
		add_item(item)
