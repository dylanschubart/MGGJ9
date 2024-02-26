extends Node

const FILE_PATH = "user://savegame.tres"

func save_game():
	#Start getting all the data to save
	var save_data:SaveData = SaveData.new()
	
	#Get the current scene
	save_data.current_scene = SceneManager.current_scene
	#call all needed save functions for all needed objects
	get_tree().call_group("save_load_events", "on_save_game")
	
	#Save the data
	ResourceSaver.save(save_data, FILE_PATH)
	print_debug("Saved Game")
	
func load_game():
	#Start getting the saved data from the savefile
	if FileAccess.file_exists(FILE_PATH):
		var saved_game:SaveData = load(FILE_PATH) as SaveData
		#Set the current scene
		SceneManager.current_scene = saved_game.current_scene
		get_tree().call_group("save_load_events", "before_on_load_game")
		#if restored_node.has_method("on_load_game"):
			#restored_node.on_load_game() 
		get_tree().call_group("save_load_events", "on_load_game")
		print_debug("Loaded Game")
		return {"file_exists": true}
	else:
		return {"file_exists": false}

func delete_save():
	#Start getting the saved data from the savefile
	if FileAccess.file_exists(FILE_PATH):
		var dir = DirAccess.open("user://")
		dir.remove(FILE_PATH)
		
