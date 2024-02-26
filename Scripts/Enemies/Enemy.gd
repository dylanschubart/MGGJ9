extends Node2D

@export var enemy_resource: Resource

@onready var health: int
@onready var sprite = $Sprite2D
@onready var loot: Array

func _ready():
	add_to_group("enemy")
	sprite.set_texture(enemy_resource.texture)
	health = enemy_resource.health
	loot = enemy_resource.loot
