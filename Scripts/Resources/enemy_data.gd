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
	Ui.combat_animation_player.play("inflicting_dmg")
	SoundManager.playSound("player_attack_purify")
	SoundManager.playSound("tutorial_enemy_taking_dmg")
	await Ui.combat_animation_player.animation_finished
	if new_health <= 0:
		death()
	else:
		health = new_health
		LogManager.write_to_log(enemy_name + " takes " + str(spell_data.damage) + " damage");
		LogManager.write_to_log(enemy_name + " now has " + str(health) + " health");
		await attack(player)
		Ui.refresh_stats_UI(player)


func attack(player: Node):
	Ui.combat_animation_player.play("taking_dmg")
	Ui.combat_particles.restart()
	SoundManager.playSound("player_taking_dmg")
	await Ui.combat_animation_player.animation_finished
	player.character_data.cur_hit_points = player.character_data.cur_hit_points - damage
	var text = enemy_name + " " + log_attack_text + " " + str(damage) + " damage"
	LogManager.write_to_log(text)


	
func death():
	SoundManager.playSound("tutorial_enemy_death")
	dead = true
	LogManager.write_to_log(enemy_name + " is dead!")
	CombatManager.end_fight()
	for item in loot:
		InventoryManager.add_item(item)
		LogManager.write_to_log("You received %s" % item.item_name)
