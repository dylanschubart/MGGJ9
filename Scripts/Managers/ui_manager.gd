extends Node

var dialogue = load("res://Dialogue/Intro.dialogue")
var dialogue_line = await DialogueManager.get_next_dialogue_line(dialogue, "start")

@onready var game_ui = $CanvasLayer/GameUI
@onready var dialogue_box = $CanvasLayer/GameUI/DialogueBox
@onready var logBox = $CanvasLayer/GameUI/LogBox
@onready var focused_character = $CanvasLayer/GameUI/FocusedCharacter
@onready var equipment_list = $CanvasLayer/GameUI/Equipment/EquipmentList
@onready var equipment_popup = $CanvasLayer/GameUI/Equipment/EquipmentList/EquipmentPopup
@onready var inventory_list = $CanvasLayer/GameUI/Inventory/InventoryList
@onready var inventory_popup = $CanvasLayer/GameUI/Inventory/InventoryList/InventoryPopUp
@onready var interaction_button_bar = $CanvasLayer/GameUI/InteractionButtonBar
@onready var title_screen = $CanvasLayer/TitleScreen
@onready var interaction_label = $CanvasLayer/GameUI/InteractionLabel
@onready var dialogue_box_label = $CanvasLayer/GameUI/DialogueBox/DialogueLabel

func _ready():
	pass

func _process(_delta):
	interaction_label.position = get_viewport().get_mouse_position() + Vector2(-5,10)

func toggle_element(element:Node):
	if element.is_visible():
		element.set_visible(false)
	else:
		element.set_visible(true)
		
func set_interaction_label(text:String):
	interaction_label.text = text
		
func _on_start_pressed():
	toggle_element(title_screen)
	toggle_element(game_ui)
	
	if SaveManager.load_game().file_exists:
		print_debug("Loaded %s" % SceneManager.current_scene)
		SceneManager.change_scene(SceneManager.current_scene)
	else:
		dialogue_box_label.dialogue_line = dialogue_line
		dialogue_box_label.type_out()
		print_debug("No Loaded Scene")
		SceneManager.change_scene(SceneManager.scenes.abandoned_cellar)

func _unhandled_input(event: InputEvent) -> void:
	#get_viewport().set_input_as_handled()
	var mouse_was_clicked: bool = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()
	if dialogue_box_label.is_typing && mouse_was_clicked:
		dialogue_box_label.skip_typing()
		return
	if dialogue_line && mouse_was_clicked:
		next(dialogue_line.next_id)
	
func next(next_id: String):
	print_debug("next line %s" %next_id)
	dialogue_line = await dialogue.get_next_dialogue_line(next_id)
	if dialogue_line:
		dialogue_box_label.dialogue_line = dialogue_line
		dialogue_box_label.type_out()
	else:
		toggle_element(dialogue_box)
	
func _on_options_pressed():
	pass # Replace with function body.

func _on_exit_pressed():
	get_tree().quit()


func _on_save_pressed():
	SaveManager.save_game()


func _on_load_pressed():
	if SaveManager.load_game().file_exists:
		print_debug("Loaded %s" % SceneManager.current_scene)
		SceneManager.change_scene(SceneManager.current_scene)
		
	if title_screen.is_visible():
		title_screen.set_visible(false)
		
	if !game_ui.is_visible():
		game_ui.set_visible(true)

func _on_button_pressed():
	SceneManager.change_scene(SceneManager.scenes.abandoned_cellar2)


func _on_delete_pressed():
	SaveManager.delete_save()

func set_currentscene_label(name:String):
	$CanvasLayer/Debug/Label/currentScene.text = name


func _on_second_scene_2_pressed():
	SceneManager.change_scene(SceneManager.scenes.abandoned_cellar)

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
