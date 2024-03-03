extends Node2D

#var room_data: RoomData: set = set_room_data
var room_data: RoomData
enum ROOM_NAMES {abandoned_cellar, abandoned_cellar_2}
@export var room_name: ROOM_NAMES
@export var interactables: Array[InteractableData]
@export var enemies: Array[EnemyData]
@export var current_scene: bool
@export var scene_path: String
var room_key: String

func _ready():

	room_key = ROOM_NAMES.find_key(room_name)
	load_room()

func load_room():
	if Ui.save.save_exists() && Ui.save.rooms.has(room_key):
		room_data = Ui.save.rooms[room_key]
		print_debug("saved room")
		var persistent_nodes = get_tree().get_nodes_in_group("persistent")
		var interactable_node = get_node("Interactables")
		var enemy_node = get_node("Enemies")
		for node in persistent_nodes:
			interactable_node.remove_child(node)
			node.queue_free()
			
		for interactable in room_data.interactables:
			var interactable_scene = load(interactable.scene_path)
			var new_interactable = interactable_scene.instantiate()
			new_interactable.interactable_data = interactable
			interactable_node.add_child(new_interactable)
		
		for enemy in room_data.enemies:
			if not enemy.dead:
				var enemy_scene = load(enemy.scene_path)
				var new_enemy = enemy_scene.instantiate()
				new_enemy.enemy_data = enemy
				enemy_node.add_child(new_enemy)
			
	else:
		print_debug("create new room")
		Ui.save.rooms[ROOM_NAMES.find_key(room_name)] = RoomData.new()
		room_data = Ui.save.rooms[ROOM_NAMES.find_key(room_name)]
		room_data.room_name = ROOM_NAMES.find_key(room_name)
		
		var interactable_parent = get_node("Interactables")
		var interactable_children = interactable_parent.get_children()
		var temp_interactables: Array = []
		for node in interactable_children:
			temp_interactables.append(node.interactable_data)
			
		room_data.interactables = temp_interactables
		var enemy_parent = get_node("Enemies")
		var enemy_children = enemy_parent.get_children()
		var temp_enemies: Array = []
		for node in enemy_children:
			temp_enemies.append(node.enemy_data)
			
		room_data.enemies = temp_enemies
		room_data.current_scene = current_scene
		room_data.scene_path = scene_path
		Ui.save.save_game()
		
