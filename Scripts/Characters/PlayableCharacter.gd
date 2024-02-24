extends Control

#Starting stats element
@export var startingStats: CharacterData

#Elements we need to be able to change
@onready var hp = $Character_image/HP/HP_VALUE
@onready var mana = $Character_image/MANA/MANA_VALUE
@onready var sanity = $Character_image/SAN/SAN_VALUE
@onready var corruption = $Character_image/COR/COR_VALUE
@onready var strength = $Character_image/STR/STR_VALUE
@onready var intelligence = $Character_image/INT/INT_VALUE
@onready var speed = $Character_image/SPD/SPD_VALUE
@onready var wisdom = $Character_image/WIS/WIS_VALUE
#End changeable elements

# Called when the node enters the scene tree for the first time.
func _ready():
	#Set UI
	hp.text = str(startingStats.curhitpoints) + "/" +  str(startingStats.maxhitpoints)
	mana.text = str(startingStats.curmana) + "/" +  str(startingStats.maxmana)
	sanity.text = str(startingStats.sanity)
	corruption.text = str(startingStats.corruption)
	strength.text = str(startingStats.strength)
	intelligence.text = str(startingStats.intelligence)
	speed.text = str(startingStats.speed)
	wisdom.text = str(startingStats.wisdom)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _on_save_loaded():
	pass

func _on_saving():
	pass
