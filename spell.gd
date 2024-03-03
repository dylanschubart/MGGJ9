extends Node

var spell_data: SpellData
@export var spell_name: String
@export var damage: int
@export var heal: int

func _ready():
	add_to_group("spell")
	if Ui.save.save_exists() && spell_data:
		name = spell_data.spell_name
	else:
		spell_data = SpellData.new()
		spell_data.spell_name = spell_name
		name = spell_data.spell_name
		spell_data.damage = damage
		spell_data.heal = heal
