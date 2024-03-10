extends Node

var item_list: Array[ItemData] = []

func set_inventory():
	Ui.inventory_list.clear()
	item_list.clear()
	var items_nodes = get_tree().get_nodes_in_group("inventory")
	for node in items_nodes:
		item_list.append(node.item_data)
		Ui.inventory_list.add_item(node.item_data.item_name, null, true)
	return item_list

func add_item(item_data: ItemData):
	var inventory_item_node = Ui.items
	var item = load("res://Scenes/ReusableScenes/item.tscn")
	var instantiated_item = item.instantiate()
	instantiated_item.add_to_group("inventory")
	instantiated_item.item_data = item_data
	instantiated_item.item_name = item_data.item_name
	instantiated_item.item_examine_text = item_data.item_examine_text
	instantiated_item.item_equipable = item_data.item_equipable
	instantiated_item.item_equiped = item_data.item_equiped
	inventory_item_node.add_child(instantiated_item)
	set_inventory()
	
func remove_item(index: int):
	var item_nodes = get_tree().get_nodes_in_group("inventory")
	item_nodes[index].remove_from_group("inventory")
	item_nodes[index].queue_free()
	set_inventory()
	
func examine_item(index):
	LogManager.write_to_log(item_list[index].item_examine_text)
