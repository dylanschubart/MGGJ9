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

func take_damage(spell_data: SpellData, player: Node):
	var new_health = health - spell_data.damage
	if new_health <= 0:
		death()
	else:
		health = new_health
		var text = enemy_name + "'s new health " + str(health)
		LogManager.write_to_log(text)
		await attack(player)
		Ui.refresh_stats_UI(player)
		# Update health in UI

func attack(player: Node):
	player.character_data.cur_hit_points = player.character_data.cur_hit_points - damage
	var text = enemy_name + " " + log_attack_text + " " + str(damage) + " damage"
	LogManager.write_to_log(text)
	# send new Character Health to Player
	
func death():
	dead = true
	LogManager.write_to_log("enemy is dead")
	CombatManager.end_fight()
	# do something with loot
	
	
