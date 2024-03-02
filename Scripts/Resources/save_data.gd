class_name SaveData
extends Resource
#E 0:00:03:0129   save_data.gd:14 @ save_game(): Resource was not pre cached for the resource section, bug?
# bug with .tres file, fix with .res
const FILE_PATH = "user://savegame.tres"

#Data to Save
@export var rooms: Dictionary
@export var characters: Dictionary
@export var inventory: InventoryData
@export var equipment: EquipmentData

func save_game():
	ResourceSaver.save(self, FILE_PATH)

func save_exists():
	return ResourceLoader.exists(FILE_PATH)
	
func load_game():
	#Start getting the saved data from the savefile
	#if not ResourceLoader.has_cached(FILE_PATH):
	return ResourceLoader.load(FILE_PATH, "", ResourceLoader.CACHE_MODE_REUSE)

func delete_save():
	#Start getting the saved data from the savefile
	if FileAccess.file_exists(FILE_PATH):
		var dir = DirAccess.open("user://")
		dir.remove(FILE_PATH)
		
