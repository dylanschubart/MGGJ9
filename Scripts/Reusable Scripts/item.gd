extends Node

@export var item_data: ItemData
# @export var item_name: String
# @export var item_examine_text: String
# @export var item_equipable: bool
# @export var item_equiped: bool

func _ready():
	name = item_data.item_name
	if item_data.item_equipable:
		if item_data.item_equiped:
			add_to_group("equipment")
		elif item_data.item_in_inventory:
			add_to_group("inventory")
		
