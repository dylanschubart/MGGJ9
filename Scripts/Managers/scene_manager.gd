extends Node

@export var current_scene: PackedScene
@export var scenes:Dictionary = {
	"abandoned_cellar" : preload("res://Scenes/Locations/abandoned_place.tscn"),
	"abandoned_cellar2" : preload("res://Scenes/Locations/abandoned_place_2.tscn")
}
var current_scene_list = []

func ready():
	pass

func change_scene(scene: PackedScene):
	if scene:
		if current_scene_list:
			remove_child(current_scene_list[0])
			current_scene_list.remove_at(0)
		var next_level = scene.instantiate()
		add_child(next_level)
		current_scene_list.append(next_level)
		current_scene = scene
		
		# DEBUG
		Ui.set_currentscene_label(scenes.find_key(scene))
	
