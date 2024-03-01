extends Node
#class_name SceneManager

var current_scene: Node
var room_scenes: Dictionary = {
	"abandoned_cellar": "res://Scenes/Locations/abandoned_cellar.tscn",
	"abandoned_cellar_2": "res://Scenes/Locations/abandoned_cellar_2.tscn",
}

func change_scene(room_scene: String):
	if room_scene:
		if current_scene:
			var key = current_scene.ROOM_NAMES.find_key(current_scene.room_name)
			var room_data = Ui.save.rooms[key]
			room_data.current_scene = false
			remove_child(current_scene)
		
		print_debug(room_scene)
		var load_level = load(room_scene)
		var instantiated_level = load_level.instantiate()
		add_child(instantiated_level)
		current_scene = instantiated_level
		
		#Ui.save.rooms.find_key()
		var key = room_scenes.find_key(room_scene)
		
		var room_data = Ui.save.rooms[key]
		room_data.current_scene = true
		Ui.save.save_game()
		# DEBUG
		Ui.set_currentscene_label(room_data.room_name)
	
