@tool
extends Area2D

var interactable_data: InteractableData

@export_category("Mouse Interaction Label Text")
@export var mouse_text: String
@export_category("Is it unlockable?")
@export var locked: bool
@export_category("Is there a first Interaction Text?")
@export var first_interaction: bool
@export_category("Log Text")
@export var log_text_first_interaction: String
@export var log_text_interaction: String
@export var log_text_locked_interaction: String
@export_category("Interaction")
@export var interaction: InteractableData.INTERACTION
@export var disable_interaction: bool
@export var selected_room: InteractableData.ROOMS

# Data for Loading
var scene_path = "res://Resources/Scenes/Resources/interactable.tscn"
var collision: CollisionShape2D
var interactable_position: Vector2
var col_shape: Shape2D
var col_size: Vector2
var room : String
var interactable : Node


func _ready():
	if Ui.save.save_exists() && interactable_data:
		interactable = self
		mouse_text = interactable_data.mouse_text
		mouse_text = interactable_data.mouse_text
		locked = interactable_data.locked
		first_interaction = interactable_data.first_interaction
		log_text_first_interaction = interactable_data.log_text_first_interaction
		log_text_interaction = interactable_data.log_text_interaction
		log_text_locked_interaction = interactable_data.log_text_locked_interaction
		disable_interaction = interactable_data.disable_interaction
		col_shape = interactable_data.col_shape
		col_size = interactable_data.col_size
		scene_path = interactable_data.scene_path
		selected_room = interactable_data.destination
		interaction = interactable_data.action
		interactable_position = interactable_data.interactable_position
		
		#set the nodes up and add the collision shape
		set_global_position(interactable_position)
		var collision = CollisionShape2D.new()
		collision.set_shape(col_shape)
		collision.get_shape().size = col_size
		add_child(collision)
	else:
		
		interactable = self
		collision = get_child(0)
		col_shape = collision.get_shape()
		col_size = col_shape.size
		interactable_position = get_position()
		
		interactable_data = InteractableData.new()
		interactable_data.mouse_text = mouse_text
		interactable_data.locked = locked
		interactable_data.first_interaction = first_interaction
		interactable_data.log_text_first_interaction = log_text_first_interaction
		interactable_data.log_text_interaction = log_text_interaction
		interactable_data.log_text_locked_interaction = log_text_locked_interaction
		interactable_data.disable_interaction = disable_interaction
		interactable_data.col_shape = col_shape
		interactable_data.col_size = col_size
		interactable_data.interactable_position = interactable_position
		interactable_data.scene_path = scene_path
		interactable_data.destination = selected_room
		interactable_data.action = interaction
	
	if selected_room != InteractableData.ROOMS.NONE:
		var key = InteractableData.ROOMS.find_key(selected_room)
		#print_debug("selected_room %s" % key)
		room = key
		#print_debug("room %s" % room)

func _get_configuration_warnings():
	var warnings: PackedStringArray
	if not mouse_text:
		warnings.append("mouse_text must be set.")
	return warnings

func _on_mouse_entered():
	interactable_data.set_label()

func _on_mouse_exited():
	interactable_data.remove_label()

func _on_input_event(viewport, event, shape_idx):
		if (event is InputEventMouseButton && event.pressed && event.button_index == MOUSE_BUTTON_LEFT):
			interactable_data.interaction(interaction, room, interactable)
			Ui.save.save_game()
