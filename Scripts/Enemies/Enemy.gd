extends Node2D

var enemy_data: EnemyData

#Starting Stats
@export_category("Enemy Starting Stats")
@export var enemy_name: String
@export var texture: Texture2D
@export var health: int
@export var damage: int

@export_category("Enemy attack Text, damage Number will be added to the end")
@export var log_attack_text: String

@export_category("Loot")
@export var loot: Array[ItemData]

@onready var sprite = $Sprite2D

var dead: bool


func _ready():
	add_to_group("enemy")
	add_to_group("persistent")
	self.hide()
		
	if Ui.save.save_exists() && enemy_data:
		print_debug("load enemy")
		enemy_name = enemy_data.enemy_name
		name = enemy_name
		sprite.set_texture(texture)
	else:
		print_debug("create new enemy")
		enemy_data = EnemyData.new()
		enemy_data.enemy_name = enemy_name
		name = enemy_name
		enemy_data.texture = texture
		sprite.set_texture(texture)
		enemy_data.health = health
		var items = get_node("Loot").get_children()
		var tmp_list: Array[ItemData] = []
		for item in items:
			tmp_list.append(item.item_data)
		enemy_data.loot = tmp_list
		enemy_data.dead = dead
		enemy_data.damage = damage
		enemy_data.log_attack_text = log_attack_text
