extends Control

#Starting stats element
var character_data: CharacterData

@export_category("Character Starting Stats")
@export var character_name: String
@export var active_character: bool
@export var texture: Texture2D
#rpg-resources
@export var max_hit_points:int = 10
@export var cur_hit_points:int = 10
@export var max_mana:int = 10
@export var cur_mana:int = 10
@export var sanity:int = 0
@export var corruption:int = 0
#stats
@export var strength:int = 2
@export var intelligence:int = 6
@export var speed:int = 3
@export var wisdom:int = 5

#Elements we need to be able to change
@onready var hp_label = $Character_image/HP/HP_VALUE
@onready var mana_label = $Character_image/MANA/MANA_VALUE
@onready var sanity_label = $Character_image/SAN/SAN_VALUE
@onready var corruption_label = $Character_image/COR/COR_VALUE
@onready var strength_label = $Character_image/STR/STR_VALUE
@onready var intelligence_label = $Character_image/INT/INT_VALUE
@onready var speed_label = $Character_image/SPD/SPD_VALUE
@onready var wisdom_label = $Character_image/WIS/WIS_VALUE
#End changeable elements
@onready var character_texture: TextureRect = $Character_image
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("playable")
	if Ui.save.save_exists() && Ui.save.characters.has(character_name):
		character_data = Ui.save.characters[character_name]
		character_texture.set_texture(character_data.texture)
		var spell_nodes = get_tree().get_nodes_in_group("spell")
		var spell_node = get_node("spells")
		for node in spell_nodes:
			print_debug(node)
			spell_node.remove_child(node)
			node.queue_free()
		
		for spell in character_data.spells:
			print_debug(spell)
			var spell_scene = load(spell.scene_path)
			var new_spell = spell_scene.instantiate()
			new_spell.spell_data = spell
			spell_node.add_child(new_spell)
	else:
		character_data = CharacterData.new()
		Ui.save.characters[character_name] = character_data
		character_data.character_name = character_name 
		character_data.texture = texture
		character_texture.set_texture(texture)
		character_data.max_hit_points = max_hit_points
		character_data.cur_hit_points = cur_hit_points
		character_data.max_mana = max_mana
		character_data.cur_mana = cur_mana
		character_data.sanity = sanity
		character_data.corruption = corruption
		character_data.strength = strength
		character_data.intelligence = intelligence
		character_data.speed = speed
		character_data.wisdom = wisdom
		character_data.active_character = active_character
		var spells_node = get_node("spells").get_children()
		var temp_list: Array[SpellData] = []
		for spell in spells_node:
			temp_list.append(spell.spell_data)
		character_data.spells = temp_list

	#Set UI
	hp_label.text = str(character_data.cur_hit_points) + "/" +  str(character_data.max_hit_points)
	mana_label.text = str(character_data.cur_mana) + "/" +  str(character_data.max_mana)
	sanity_label.text = str(character_data.sanity)
	corruption_label.text = str(character_data.corruption)
	strength_label.text = str(character_data.strength)
	intelligence_label.text = str(character_data.intelligence)
	speed_label.text = str(character_data.speed)
	wisdom_label.text = str(character_data.wisdom)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _on_save_loaded():
	pass

func _on_saving():
	pass
