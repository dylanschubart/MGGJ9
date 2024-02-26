extends Node2D

@onready var enemy: Node = $Enemy

func _on_enemy_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed && event.button_index == MOUSE_BUTTON_LEFT):
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		Ui.set_interaction_label("")
		CombatManager.start_fight(enemy)


func _on_enemy_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	Ui.set_interaction_label("???")


func _on_enemy_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	Ui.set_interaction_label("")


func _on_abandonedcellar_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	Ui.set_interaction_label("Back to Cellar")


func _on_abandonedcellar_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	Ui.set_interaction_label("")


func _on_abandonedcellar_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed && event.button_index == MOUSE_BUTTON_LEFT):
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		Ui.set_interaction_label("")
		SceneManager.change_scene(SceneManager.scenes.abandoned_cellar)
