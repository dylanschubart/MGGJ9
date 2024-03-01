extends Node2D

@export var enemy_data: EnemyData

@onready var health: int
@onready var sprite = $Sprite2D
@onready var loot: Array

func _ready():
	add_to_group("enemy")
	sprite.set_texture(enemy_data.texture)
	health = enemy_data.health
	loot = enemy_data.loot
