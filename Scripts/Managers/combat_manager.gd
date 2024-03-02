extends Node


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
	for enemy in enemy_nodes:
			enemy.show()
			
	for player in player_nodes:
		if player.character_data.active_character:
			create_action_bar(player.character_data)
			

func create_action_bar(character_data: CharacterData):
	for action in character_data.ACTION.keys():
		if action != character_data.ACTION.find_key(character_data.ACTION.NONE):
			var action_button = load("res://Scenes/ReusableScenes/spell_button.tscn")
			var button_instance = action_button.instantiate()
			button_instance.name = action
			Ui.actions_hbox.add_child(button_instance)
			Ui.actions_hbox.show()
			
	for spell in character_data.spells:
		var spell_button = load("res://Scenes/ReusableScenes/spell_button.tscn")
		var button_instance = spell_button.instantiate()
		button_instance.name = spell.spell_name
		Ui.spells_hbox.add_child(button_instance)
		Ui.spells_hbox.hide()
		
	Ui.toggle_element(Ui.interaction_button_bar)

func attack():
	pass
