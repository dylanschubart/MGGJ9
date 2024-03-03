extends Node

var item_data: ItemData
@export var item_name: String
@export var item_examine_text: String
@export var item_equipable: bool
@export var item_equiped: bool

func _ready():
	if item_equiped:
		add_to_group("inventory")
	else:
		add_to_group("equipment")
	
	if Ui.save.save_exists() && item_data:
		name = item_data.item_name
	else:
		item_data = ItemData.new()
		item_data.item_name = item_name
		name = item_data.item_name
		item_data.item_equipable = item_equipable
		item_data.item_examine_text = item_examine_text
