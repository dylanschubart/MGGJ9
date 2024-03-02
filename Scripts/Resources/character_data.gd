class_name CharacterData
extends Resource

#name
@export var character_name: String
@export var texture: Texture2D
@export var scene_path: String = "res://Scenes/ReusableScenes/playable_character.tscn"
#rpg-resources
@export var max_hit_points:int = 10
@export var max_mana:int = 10
@export var cur_hit_points:int = 10
@export var cur_mana:int = 10
@export var sanity:int = 0
@export var corruption:int = 0
#stats
@export var strength:int = 2
@export var intelligence:int = 6
@export var speed:int = 3
@export var wisdom:int = 5

@export var active_character: bool

enum ACTION {NONE, EXAMINE, ATTACK, FLEE}
@export var action: ACTION
@export var spells: Array[SpellData]
@export var current_actions: Array
