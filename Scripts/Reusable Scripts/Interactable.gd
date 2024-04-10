@tool
extends Area2D

@export var interactable_data: InteractableData

@onready var sprite = $Sprite2D
var collision: CollisionShape2D
# var col_shape: Shape2D
# var col_size: Vector2
# var interactable_position: Vector2
var room : String


func _ready():
	add_to_group("persistent")
	sprite.set_texture(interactable_data.sprite)
	name = interactable_data.interactable_name

	if interactable_data.destination != InteractableData.ROOMS.NONE:
		var key = InteractableData.ROOMS.find_key(interactable_data.destination)
		room = key

func initialize_interactable():
	
	collision = $CollisionShape2D
	interactable_data.col_shape = collision.get_shape()
	interactable_data.col_size = collision.get_shape().size
	interactable_data.interactable_position = get_position()

func load_interactable():
	collision = CollisionShape2D.new()
	collision.set_shape(interactable_data.col_shape)
	collision.get_shape().size = interactable_data.col_size
	set_global_position(interactable_data.interactable_position)
	add_child(collision)



func _get_configuration_warnings():
	var warnings: PackedStringArray = []
	if not interactable_data.mouse_text:
		warnings.append("mouse_text must be set.")
	if interactable_data.action == InteractableData.INTERACTION.DOOR && interactable_data.destination == InteractableData.ROOMS.NONE:
		warnings.append("destination_room must be set if Interaction is Door")
	return warnings

func _on_mouse_entered():
	interactable_data.set_label()

func _on_mouse_exited():
	interactable_data.remove_label()

func _on_input_event(_viewport, event, _shape_idx):
		if (event is InputEventMouseButton && event.pressed && event.button_index == MOUSE_BUTTON_LEFT):
			interactable_data.interact(interactable_data.action, room)
			Ui.save.save_game()
