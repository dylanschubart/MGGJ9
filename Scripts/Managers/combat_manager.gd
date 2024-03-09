extends Node
var current_enemy: Node
var current_character: Node
var current_room: Node
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func start_fight():
	SoundManager.playMusic("crxw-unpledged-alliance")
	
	var enemy_nodes = get_tree().get_nodes_in_group("enemy")
	var player_nodes = get_tree().get_nodes_in_group("playable")
	var room_nodes = get_tree().get_nodes_in_group("room")
	for enemy in enemy_nodes:
			current_enemy = enemy
			LogManager.write_to_log(current_enemy.enemy_data.enemy_name + " Attacks!");
			enemy.show()
			
	for player in player_nodes:
		if player.character_data.active_character:
			current_character = player
			create_spell_bar(player.character_data)
	
	for room in room_nodes:
			current_room = room
			
func end_fight():
	SoundManager.playMusic("crxw-v0idness")
	current_enemy.hide();
	Ui.save.save_game()
	Ui.toggle_element(Ui.interaction_button_bar)

	if current_room.room_data.enemy_interactable_sprite:
		var enemy_sprite_node = current_room.get_node("EnemySprites")
		var enemy_sprites = enemy_sprite_node.get_children()
		for sprite in enemy_sprites:
			print_debug(sprite)
			sprite.set_texture(null)
	

func create_spell_bar(character_data: CharacterData):
	for spell in character_data.spells:
		var spell_button = load("res://Scenes/ReusableScenes/spell_button.tscn")
		var button_instance = spell_button.instantiate()
		button_instance.spell_data = spell
		button_instance.name = spell.spell_name
		Ui.spells_hbox.add_child(button_instance)
		Ui.spells_hbox.hide()
		
	Ui.toggle_element(Ui.interaction_button_bar)

func use_spell(spell_data):
	if spell_data.damage > 0:
		# LogManager.write_to_log(current_character.name + " casts " + spell_data.spell_name + " against " + current_enemy.enemy_data.enemy_name);
		
		current_enemy.enemy_data.take_damage(spell_data, current_character)
	if spell_data.heal > 0:
		LogManager.write_to_log(current_character.name + " casts " + spell_data.spell_name + " to heal themself.");
		pass
