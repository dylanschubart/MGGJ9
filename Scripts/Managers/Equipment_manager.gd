extends Node

func set_equipment():
	var equipment_nodes = get_tree().get_nodes_in_group("equipment")
	var equipment_list : Array[ItemData] = []
	for node in equipment_nodes:
		equipment_list.append(node.item_data)
		Ui.equipment_list.add_item(node.item_data.item_name, null, true)
	return equipment_list
