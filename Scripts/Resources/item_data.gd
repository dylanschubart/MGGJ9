extends Resource
class_name ItemData

@export var item_name: String
@export var item_examine_text: String
@export var item_equipable: bool
@export var item_type: ITEM_TYPES
@export var item_equiped: bool
@export var item_in_inventory: bool
@export var scene_path: String = "res://Scenes/ReusableScenes/item.tscn"

enum ITEM_TYPES {
    weapon,
    helmet,
    chest,
    pants,
    boots,
    key_items,
    misc
}