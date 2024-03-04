extends Node

var equipment_list: Array[ItemData] = []

func set_equipment():
	var equipment_nodes = get_tree().get_nodes_in_group("equipment")
	for node in equipment_nodes:
		equipment_list.append(node.item_data)
		Ui.equipment_list.add_item(node.item_data.item_name, null, true)
	return equipment_list

func examine_item(index):
	LogManager.write_to_log(equipment_list[index].item_examine_text)
