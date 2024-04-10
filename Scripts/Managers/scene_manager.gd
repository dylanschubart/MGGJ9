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
			var current_room_key = current_scene.room_data.ROOM_NAMES.find_key(current_scene.room_data.room_name)
			var current_room_data = Ui.save.rooms[current_room_key]
			current_room_data.current_scene = false
			remove_child(current_scene)
		
		print_debug(room_scene)
		var load_level = load(room_scene)
		var instantiated_level = load_level.instantiate()
		add_child(instantiated_level)
		current_scene = instantiated_level
		
		#Ui.save.rooms.find_key()
		var room_key = room_scenes.find_key(room_scene)
		var room_data = Ui.save.rooms[room_key]

		room_data.current_scene = true
		Ui.save.save_game()
		# DEBUG
		print_debug(room_data.room_name)
		var room_name_key = room_data.ROOM_NAMES.find_key(room_data.room_name)

		Ui.set_currentscene_label(room_name_key)
	
