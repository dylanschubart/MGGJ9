class_name InteractableData
extends Resource

@export var interactable_name: String
@export var mouse_text: String
@export var locked: bool
@export var first_interaction: bool
@export var log_text_first_interaction: String
@export var log_text_interaction: String
@export var log_text_locked_interaction: String
@export var disable_interaction: bool
@export var scene_path = "res://Scenes/ReusableScenes/interactable.tscn"
@export var interactable_position: Vector2
@export var col_shape: Shape2D
@export var col_size: Vector2
@export var destination: int
@export var action: int

enum ROOMS {NONE ,abandoned_cellar, abandoned_cellar_2}
enum INTERACTION {DOOR, EXAMINE, PICK_UP, BATTLE}

func set_label():
	if disable_interaction:
		return
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	#print_debug(mouse_text)
	Ui.set_interaction_label(mouse_text)
	
	
func remove_label():
	if disable_interaction:
		return
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	Ui.set_interaction_label("")
	

func interaction(interaction: INTERACTION, room: String = "", node: Node = null):
	if disable_interaction:
		return
	remove_label()
	match interaction:
		INTERACTION.DOOR:
			if locked:
				LogManager.write_to_log(log_text_locked_interaction)
			else:
				SceneManager.change_scene(SceneManager.room_scenes[room])
		INTERACTION.EXAMINE:
			if first_interaction:
				LogManager.write_to_log(log_text_first_interaction)
			else:
				LogManager.write_to_log(log_text_interaction)
				
		INTERACTION.PICK_UP:
			LogManager.write_to_log(log_text_interaction)
			disable_interaction = true
			
		INTERACTION.BATTLE:
			LogManager.write_to_log(log_text_interaction)
			disable_interaction = true
			CombatManager.start_fight()
	
