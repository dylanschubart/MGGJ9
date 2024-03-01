extends Node

var save: SaveData = SaveData.new()

var dialogue = load("res://Dialogue/Intro.dialogue")
var dialogue_line

@onready var game_ui = $CanvasLayer/GameUI
@onready var dialogue_box = $CanvasLayer/GameUI/DialogueBox
@onready var logBox = $CanvasLayer/GameUI/LogBox
@onready var log_rich_text = $CanvasLayer/GameUI/LogBox/Log
@onready var focused_character = $CanvasLayer/GameUI/FocusedCharacter
@onready var equipment_list = $CanvasLayer/GameUI/Equipment/EquipmentList
@onready var equipment_popup = $CanvasLayer/GameUI/Equipment/EquipmentList/EquipmentPopup
@onready var inventory_list = $CanvasLayer/GameUI/Inventory/InventoryList
@onready var inventory_popup = $CanvasLayer/GameUI/Inventory/InventoryList/InventoryPopUp
@onready var interaction_button_bar = $CanvasLayer/GameUI/InteractionButtonBar
@onready var title_screen = $CanvasLayer/TitleScreen
@onready var interaction_label = $CanvasLayer/GameUI/InteractionLabel
@onready var dialogue_box_label = $CanvasLayer/GameUI/DialogueBox/DialogueLabel
@onready var character_label = $CanvasLayer/GameUI/DialogueBox/CharacterLabel
@onready var next_char_timer = $CanvasLayer/GameUI/LogBox/nextChar

func _ready():
	SoundManager.playMusic("crxw-v0idness")

func _process(_delta):
	interaction_label.position = get_viewport().get_mouse_position() + Vector2(-5,10)

func toggle_element(element:Node):
	if element.is_visible():
		element.set_visible(false)
	else:
		element.set_visible(true)
		
func set_interaction_label(text:String):
	interaction_label.text = text

func start_dialogue(dialogue_resource):
	toggle_element(dialogue_box)
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
		toggle_element(dialogue_box)
	
func _on_start_pressed():
	toggle_element(title_screen)
	toggle_element(game_ui)
	SoundManager.lowerLastMusicVolume()
	create_or_load_game()
	
func create_or_load_game():
	if save.save_exists():
		save = save.load_game()
		for room in save.rooms.values():
			if room.current_scene:
				SceneManager.change_scene(SceneManager.room_scenes[room.room_name])
	else:
		save.protagonist = CharacterData.new()
		save.side_character = CharacterData.new()
		save.inventory = InventoryData.new()
		save.equipment = EquipmentData.new()
		SceneManager.change_scene(SceneManager.room_scenes.abandoned_cellar)
		start_dialogue(dialogue)
		save.save_game()
		print_debug("new Save")
		
func _on_options_pressed():
	pass # Replace with function body.

func _on_exit_pressed():
	get_tree().quit()


func _on_save_pressed():
	save.save_game()


func _on_load_pressed():
	if save.save_exists():
		save.load_game()
		#for room in save.ROOM_DATA:
			#if room.current_scene:
				#print_debug("room current_scene!!!!!!!!!!%s" % room)
				#SceneManager.current_scene = room
				#SceneManager.change_scene(SceneManager.current_scene)
		
	if title_screen.is_visible():
		title_screen.set_visible(false)
		
	if !game_ui.is_visible():
		game_ui.set_visible(true)

func _on_button_pressed():
	SceneManager.change_scene(SceneManager.scenes.abandoned_cellar_2)


func _on_delete_pressed():
	if save.save_exists():
		save.delete_save()

func set_currentscene_label(name:String):
	$CanvasLayer/Debug/Label/currentScene.text = name


func _on_inventory_list_item_selected(index):
	inventory_popup.popup()

func _on_equipment_list_item_selected(index):
	equipment_popup.popup()


func _on_equipment_pressed():
	if equipment_list.is_visible():
		equipment_list.set_visible(false)
	else:
		equipment_list.set_visible(true)


func _on_inventory_pressed():
	if inventory_list.is_visible():
		inventory_list.set_visible(false)
	else:
		inventory_list.set_visible(true)


func _on_log_pressed():
	LogManager.write_to_log("i am testing the log! you took 4 Damage")


func _on_first_location_pressed():
	SceneManager.change_scene(SceneManager.scenes.abandoned_cellar)

func _on_nd_location_pressed():
	SceneManager.change_scene(SceneManager.scenes.abandoned_cellar_2)
