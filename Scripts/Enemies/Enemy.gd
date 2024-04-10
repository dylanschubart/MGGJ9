extends Node2D

@export var enemy_data: EnemyData

# #Starting Stats
# @export_category("Enemy Starting Stats")
# @export var enemy_name: String
# @export var texture: Texture2D
# @export var health: int
# @export var damage: int

# @export_category("Enemy attack Text, damage Number will be added to the end")
# @export var log_attack_text: String

# @export_category("Loot")
# @export var loot: Array[ItemData]

@onready var sprite = $Sprite2D

# var dead: bool

func _ready():
	add_to_group("enemy")
	add_to_group("persistent")
	self.hide()
	

func initialize_enemy():
	sprite.set_texture(enemy_data.texture)
	var items = get_node("Loot").get_children()
	var tmp_list: Array[ItemData] = []
	for item in items:
		tmp_list.append(item.item_data)
	enemy_data.loot = tmp_list

func load_enemy():
	var item_parent = get_node("Loot")
	for item in enemy_data.loot:
		var item_scene = load(item.scene_path)
		var new_item = item_scene.instantiate()
		
		new_item.item_data = item
		item_parent.add_child(new_item)
