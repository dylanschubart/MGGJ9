extends TextureButton
var spell_data = SpellData

func _on_mouse_entered():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	Ui.set_interaction_label(name)


func _on_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	Ui.set_interaction_label("")


func _on_pressed():
	CombatManager.use_spell(spell_data)
