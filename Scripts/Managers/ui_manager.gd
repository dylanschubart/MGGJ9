extends Node

var save: SaveData = SaveData.new()

var dialogue = load("res://Dialogue/Intro.dialogue")
var dialogue_line

@onready var game_ui = $CanvasLayer/GameUI

@onready var dialogue_box = $CanvasLayer/GameUI/DialogueBox
@onready var entity = $CanvasLayer/GameUI/DialogueBox/Entity
@onready var animation_player = $CanvasLayer/GameUI/DialogueBox/AnimationPlayer
@onready var logBox = $CanvasLayer/GameUI/LogBox
@onready var log_rich_text = $CanvasLayer/GameUI/LogBox/Log
@onready var focused_character = $CanvasLayer/GameUI/FocusedCharacter
@onready var protagonist = $CanvasLayer/GameUI/FocusedCharacter/PlayableCharacter
@onready var side_character = $CanvasLayer/GameUI/FocusedCharacter/PlayableCharacter2
@onready var continue_btn = $CanvasLayer/TitleScreen/VBoxContainer/Continue

#Combat
@onready var combat_animation_player = $CanvasLayer/GameUI/CombatEffects/CombatAnimationPlayer
@onready var combat_particles = $CanvasLayer/GameUI/CombatEffects/CPUParticles2D

#Items
@onready var inventory_list = $CanvasLayer/GameUI/Inventory/InventoryList
@onready var inventory_popup = $CanvasLayer/GameUI/Inventory/InventoryList/InventoryPopUp
@onready var inventory_items = $CanvasLayer/GameUI/Inventory/InventoryList/Items
var selected_item_popup_index;
#Equipment
@onready var equipment_items = $CanvasLayer/GameUI/Equipment/EquipmentList/Items
@onready var equipment_list = $CanvasLayer/GameUI/Equipment/EquipmentList
@onready var equipment_popup = $CanvasLayer/GameUI/Equipment/EquipmentList/EquipmentPopup
@onready var new_equipment_popup = $CanvasLayer/GameUI/EquipmentRemastered/EquipmentPopup
var selected_equipment_popup_index;

@onready var interaction_button_bar = $CanvasLayer/GameUI/InteractionButtonBar
@onready var title_screen = $CanvasLayer/TitleScreen
@onready var interaction_label = $CanvasLayer/GameUI/InteractionLabel
@onready var dialogue_box_label = $CanvasLayer/GameUI/DialogueBox/DialogueLabel
@onready var character_label = $CanvasLayer/GameUI/DialogueBox/CharacterLabel
@onready var next_char_timer = $CanvasLayer/GameUI/LogBox/nextChar
@onready var actions_hbox = $CanvasLayer/GameUI/InteractionButtonBar/Actions
@onready var spells_hbox = $CanvasLayer/GameUI/InteractionButtonBar/Spells

var save_exists: bool

func _ready():
	SoundManager.playMusic("crxw-v0idness")
	save_exists = save.save_exists()
	print_debug(save_exists)
	continue_btn.set_disabled(!save_exists)

func _process(_delta):
	if get_viewport().get_mouse_position() && interaction_label:
		interaction_label.position = get_viewport().get_mouse_position() + Vector2(-5,10)

func toggle_element(element:Node):
	if element.is_visible():
		element.set_visible(false)
	else:
		element.set_visible(true)
		
func set_interaction_label(text:String):
	interaction_label.text = text

func create_game():
	toggle_element(title_screen)
	toggle_element(game_ui)
	SoundManager.lowerLastMusicVolume()
	if save.save_exists():
		save.delete_save()

	save.inventory = InventoryData.new()
	save.inventory.items = InventoryManager.set_inventory()
	save.equipment = EquipmentData.new()
	save.equipment.equipedItems = EquipmentManager.set_equipment()
	SceneManager.change_scene(SceneManager.room_scenes.abandoned_cellar)
	start_dialogue(dialogue)
	save.save_game()
	print_debug("new Save")

func load_game():
	toggle_element(title_screen)
	toggle_element(game_ui)
	SoundManager.lowerLastMusicVolume()
	save = save.load_game()
	for item in equipment_items.get_children():
		item.queue_free()
		await item.tree_exited
	for item in inventory_items.get_children():
		item.queue_free()
		await item.tree_exited

	InventoryManager.load_inventory()
	EquipmentManager.load_equipment()

	for room in save.rooms.values():
		if room.current_scene:
			var room_key = room.ROOM_NAMES.find_key(room.room_name)
			SceneManager.change_scene(SceneManager.room_scenes[room_key])
		
func _on_new_game_pressed():
	SoundManager.lowerLastMusicVolume()
	create_game()

func start_dialogue(dialogue_resource):
	toggle_element(dialogue_box)
	toggle_element(entity)
	animation_player.play("Entity")
	dialogue_line = await DialogueManager.get_next_dialogue_line(dialogue_resource, "start")
	dialogue_box_label.dialogue_line = dialogue_line
	character_label.text = tr(dialogue_line.character, "dialogue")
	dialogue_box_label.type_out()
	
func _unhandled_input(event: InputEvent) -> void:
	var mouse_was_clicked: bool = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()
	if dialogue_box.is_visible() && dialogue_box_label.is_typing && mouse_was_clicked:
		dialogue_box_label.skip_typing()
		get_viewport().set_input_as_handled()
		return
	if dialogue_box.is_visible() && dialogue_line && mouse_was_clicked:
		next(dialogue_line.next_id)
		get_viewport().set_input_as_handled()
	
func next(next_id: String):
	#print_debug("next line %s" %next_id)
	dialogue_line = await dialogue.get_next_dialogue_line(next_id)
	if dialogue_line:
		character_label.text = tr(dialogue_line.character, "dialogue")
		dialogue_box_label.dialogue_line = dialogue_line
		dialogue_box_label.type_out()
	else:
		toggle_element(entity)
		toggle_element(dialogue_box)
	
func _on_continue_pressed():
	SoundManager.lowerLastMusicVolume()
	load_game()
	
func _on_options_pressed():
	pass # Replace with function body.

func _on_exit_pressed():
	get_tree().quit()

func _on_inventory_list_item_selected(index):
	inventory_popup.popup()
	selected_item_popup_index = index

func _on_equipment_list_item_selected(index):
	equipment_popup.popup()
	print_debug(index)
	selected_equipment_popup_index = index


func _on_equipment_pressed():
	toggle_element(equipment_list)
	if inventory_list.is_visible():
		toggle_element(inventory_list)

func _on_weapon_pressed():
	equipment_popup.popup()


func _on_inventory_pressed():
	toggle_element(inventory_list)
	if equipment_list.is_visible():
		toggle_element(equipment_list)

# --------> INTERACTIONBUTTONBAR ACTIONS
func _on_examine_enemy_mouse_entered():
	var btn = $"CanvasLayer/GameUI/InteractionButtonBar/Actions/Examine Enemy"
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	set_interaction_label(btn.name)


func _on_examine_enemy_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	set_interaction_label("")


func _on_examine_enemy_pressed():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	set_interaction_label("")
	var btn = $"CanvasLayer/GameUI/InteractionButtonBar/Actions/Examine Enemy"
	print_debug("clicked %s" % btn.name)


func _on_attack_mouse_entered():
	var btn = $CanvasLayer/GameUI/InteractionButtonBar/Actions/Attack
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	set_interaction_label(btn.name)


func _on_attack_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	set_interaction_label("")


func _on_attack_pressed():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	set_interaction_label("")
	var btn = $CanvasLayer/GameUI/InteractionButtonBar/Actions/Attack
	print_debug("clicked %s" % btn.name)
	spells_hbox.show()
	actions_hbox.hide()


func _on_flee_mouse_entered():
	var btn = $CanvasLayer/GameUI/InteractionButtonBar/Actions/Flee
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	set_interaction_label(btn.name)


func _on_flee_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	set_interaction_label("")


func _on_flee_pressed():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	set_interaction_label("")
	var _btn = $CanvasLayer/GameUI/InteractionButtonBar/Spells/Back

func _on_back_pressed():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	set_interaction_label("")
	var btn = $CanvasLayer/GameUI/InteractionButtonBar/Spells/Back
	print_debug("clicked %s" % btn.name)
	spells_hbox.hide()
	actions_hbox.show()

func _on_back_mouse_entered():
	var btn = $CanvasLayer/GameUI/InteractionButtonBar/Spells/Back
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	set_interaction_label(btn.name)

func _on_back_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	set_interaction_label("")

#-----------------------------> Character UI
func refresh_stats_UI(player: Node): 
	player.hp_label.text = str(player.character_data.cur_hit_points) + "/" +  str(player.character_data.max_hit_points)
	player.mana_label.text = str(player.character_data.cur_mana) + "/" +  str(player.character_data.max_mana)
	player.sanity_label.text = str(player.character_data.sanity)
	player.corruption_label.text = str(player.character_data.corruption)
	player.strength_label.text = str(player.character_data.strength)
	player.intelligence_label.text = str(player.character_data.intelligence)
	player.speed_label.text = str(player.character_data.speed)
	player.wisdom_label.text = str(player.character_data.wisdom)

# --------> DEBUG
func _on_save_pressed():
	save.save_game()

func _on_load_pressed():
	#create_or_load_game
		
	if title_screen.is_visible():
		title_screen.set_visible(false)
		
	if !game_ui.is_visible():
		game_ui.set_visible(true)

func _on_delete_pressed():
	if save.save_exists():
		save.delete_save()

func set_currentscene_label(scene_name: String):
	$CanvasLayer/Debug/Label/currentScene.text = scene_name

func _on_change_character_pressed():
	#print_debug(protagonist)
	if protagonist.is_visible():
		protagonist.hide()
		side_character.show()
	else:
		side_character.hide()
		protagonist.show()

func _on_inventory_pop_up_index_pressed(index):
	var popup_text = inventory_popup.get_item_text(index)
	if popup_text == "Examine":
		InventoryManager.examine_item(selected_item_popup_index)
	if popup_text == "Use/Equip":
		InventoryManager.use_equip(selected_item_popup_index)
	

func _on_equipment_popup_index_pressed(index):
	var popup_text = equipment_popup.get_item_text(index)
	if popup_text == "Examine":
		EquipmentManager.examine_item(selected_equipment_popup_index)
	if popup_text == "Unequip":
		EquipmentManager.unequip(selected_equipment_popup_index)



