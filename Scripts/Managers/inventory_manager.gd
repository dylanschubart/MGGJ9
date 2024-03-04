extends Node
	
func set_inventory():
	var items_nodes = get_tree().get_nodes_in_group("inventory")
	var item_list : Array[ItemData] = []
	for node in items_nodes:
		item_list.append(node.item_data)
		Ui.inventory_list.add_item(node.item_data.item_name, null, true)
	return item_list

func add_item(item_data: ItemData):
	var inventory_item_node = Ui.items
	var item = load("res://Scenes/ReusableScenes/item.tscn")
	var instantiated_item = item.instantiate()
	instantiated_item.item_data = item_data
	inventory_item_node.add_child(instantiated_item)
	set_inventory()
