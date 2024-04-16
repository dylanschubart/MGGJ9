extends Node

var equipment_list: Array[ItemData] = []

func set_equipment():
	Ui.equipment_list.clear()
	equipment_list.clear()

	var items_nodes = Ui.equipment_items.get_children()

	for node in items_nodes:
		equipment_list.append(node.item_data)
	
	Ui.save.equipment.equipedItems = equipment_list
	Ui.save.save_game()
	return equipment_list


func add_item(item_data: ItemData):
	var equipment_node = Ui.equipment_items
	var item_scene = load(item_data.scene_path)
	var instantiated_item = item_scene.instantiate()
	instantiated_item.item_data = item_data
	instantiated_item.item_data.item_equiped = true

	var type = item_data.ITEM_TYPES.find_key(item_data.item_type)
	match (type):
		"Weapon":
			Ui.equipment_weapon.disabled = false;
		"Helmet":
			Ui.equipment_helmet.disabled = false;
		"Chest":
			Ui.equipment_chest.disabled = false;
		"Pants":
			Ui.equipment_pants.disabled = false;
		"Boots":
			Ui.equipment_boots.disabled = false;

	equipment_node.add_child(instantiated_item)
	set_equipment()


func examine_item(type: String):
	var examined_item;
	for item in equipment_list:
		if item.ITEM_TYPES.find_key(item.item_type) == type:
			examined_item = item
	LogManager.write_to_log("Item type: " + type)
	LogManager.write_to_log(examined_item.item_examine_text)

func remove_item_from_equipment(removed_item: ItemData):
	var equipment_items = Ui.equipment_items.get_children()
	var item = equipment_items.find(removed_item)
	
	var type = item.item_data.ITEM_TYPES.find_key(item.item_data.item_type)
	match (type):
		"Weapon":
			Ui.equipment_weapon.disabled = true;
		"Helmet":
			Ui.equipment_helmet.disabled = true;
		"Chest":
			Ui.equipment_chest.disabled = true;
		"Pants":
			Ui.equipment_pants.disabled = true;
		"Boots":
			Ui.equipment_boots.disabled = true;
	
	item.remove_from_group("equipment")
	print_debug(item.item_data.item_name)
	item.queue_free()
	await item.tree_exited
	set_equipment()
	

func unequip(type: String):
	var equipment_items = Ui.equipment_items.get_children()
	var unequiped_item;

	for item in equipment_items:
		if item.ITEM_TYPES.find_key(item.item_type) == type:
			unequiped_item = item

	print_debug(unequiped_item.item_data.item_name)
	InventoryManager.add_item(unequiped_item.item_data)
	remove_item_from_equipment(unequiped_item)

func load_equipment():
	for item in Ui.save.equipment.equipedItems:
		print_debug(item)
		add_item(item)
