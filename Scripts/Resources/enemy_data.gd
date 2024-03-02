class_name EnemyData
extends Resource


@export var enemy_name: String
@export var texture: Texture
@export var health: int
@export var damage: int
@export var loot: Array[ItemData]
@export var scene_path: String = "res://Scenes/ReusableScenes/enemy.tscn"
@export var dead: bool
@export var log_attack_text: String

func taking_damage(damage):
	var new_health = health - damage
	if new_health <= 0:
		death()
	else:
		health = new_health
		# Update health in UI

func attack(character_health):
	character_health = character_health - damage
	var text = enemy_name + " " + log_attack_text + " " + str(damage) + " " + "damage"
	LogManager.write_to_log(text)
	# send new Character Health to Player
	
func death():
	dead = true
	# do something with loot
		
