extends Node2D

func _on_abandoned_cellar_2_mouse_entered():
	#Input.set_custom_mouse_cursor()
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	Ui.set_interaction_label("Next Room")

func _on_outside_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	Ui.set_interaction_label("Outside?")


func _on_abandoned_cellar_2_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	Ui.set_interaction_label("")


func _on_outside_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	Ui.set_interaction_label("")


func _on_abandoned_cellar_2_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed && event.button_index == MOUSE_BUTTON_LEFT):
		#print('Clicked')
		SceneManager.change_scene(SceneManager.scenes.abandoned_cellar2)
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		Ui.set_interaction_label("")


func _on_outside_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed && event.button_index == MOUSE_BUTTON_LEFT):
		print('Clicked')
		#pass # Replace with function body.
