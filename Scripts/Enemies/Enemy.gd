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

@onready var sprite = $Sprite2D

var loot: Array[ItemData]
var dead: bool


func _ready():
	self.hide()
	
	if Ui.save.save_exists() && enemy_data:
		enemy_name = enemy_data.enemy_name
		name = enemy_name
		sprite.set_texture(texture)
		
	else:
		enemy_data = EnemyData.new()
		add_to_group("enemy")
		add_to_group("persistent")
		enemy_data.enemy_name = enemy_name
		name = enemy_name
		enemy_data.texture = texture
		sprite.set_texture(texture)
		enemy_data.health = health
		enemy_data.loot = loot
		enemy_data.dead = dead
		enemy_data.damage = damage
		enemy_data.log_attack_text = log_attack_text
