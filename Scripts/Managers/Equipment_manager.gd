extends Node

var equipment_list: Array[ItemData] = []

func set_equipment():
	Ui.equipment_list.clear()
	equipment_list.clear()

	var items_nodes = Ui.equipment_items.get_children()

	for node in items_nodes:
		equipment_list.append(node.item_data)
		Ui.equipment_list.add_item(node.item_data.item_name, null, true)
	
	Ui.save.equipment.equipedItems = equipment_list
	Ui.save.save_game()
	return equipment_list


func add_item(item_data: ItemData):
	var equipment_node = Ui.equipment_items
	var item_scene = load(item_data.scene_path)
	var instantiated_item = item_scene.instantiate()
	instantiated_item.item_data = item_data
	instantiated_item.item_data.item_equiped = true
	equipment_node.add_child(instantiated_item)
	set_equipment()


func examine_item(index: int):
	var type = equipment_list[index].ITEM_TYPES.find_key(equipment_list[index].item_type)
	LogManager.write_to_log("Item type: " + type)
	LogManager.write_to_log(equipment_list[index].item_examine_text)

func remove_item_from_equipment(index: int):
	var equipment_items = Ui.equipment_items.get_children()
	var item = equipment_items[index]
	
	item.remove_from_group("equipment")
	print_debug(item.item_data.item_name)
	item.queue_free()
	await item.tree_exited
	Ui.equipment_list.remove_item(index)
	set_equipment()
	

func unequip(index: int):
	var equipment_items = Ui.equipment_items.get_children()
	var item = equipment_items[index]
	print_debug(item.item_data.item_name)
	InventoryManager.add_item(item.item_data)
	remove_item_from_equipment(index)

func load_equipment():
	for item in Ui.save.equipment.equipedItems:
		print_debug(item)
		add_item(item)