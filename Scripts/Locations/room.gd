extends Node2D

@export var room_data: RoomData

# @onready var enemy_sprite_node = $EnemySprites
@onready var enemy_parent = $Enemies
@onready var interactable_node = $Interactables

var room_key: String

func _ready():
	add_to_group("room")
	room_key = room_data.ROOM_NAMES.find_key(room_data.room_name)

	if Ui.save.save_exists() && Ui.save.rooms.has(room_key):
		load_room()
	else:
		initialize_room()

func initialize_room():
	print_debug("create new room")
	Ui.save.rooms[room_key] = room_data

	var interactable_parent = get_node("Interactables")
	var interactable_children = interactable_parent.get_children()
	var temp_interactables: Array[InteractableData] = []

	for node in interactable_children:
		node.initialize_interactable()
		temp_interactables.append(node.interactable_data)
		
	room_data.interactables = temp_interactables
	
	var enemy_children = enemy_parent.get_children()
	var temp_enemies: Array[EnemyData] = []

	for node in enemy_children:
		node.initialize_enemy()
		temp_enemies.append(node.enemy_data)
		
	room_data.enemies = temp_enemies

	Ui.save.save_game()

func load_room():
	print_debug("load room")
	room_data = Ui.save.rooms[room_key]
	
	var persistent_nodes = get_tree().get_nodes_in_group("persistent")

	for node in persistent_nodes:
		interactable_node.remove_child(node)
		node.queue_free()
		
	for interactable in room_data.interactables:
		var interactable_scene = load(interactable.scene_path)
		var new_interactable = interactable_scene.instantiate()
		if interactable.enemy:
			for enemy in room_data.enemies:
				if enemy.dead:
					interactable.sprite = null
		new_interactable.interactable_data = interactable


		new_interactable.load_interactable()
		interactable_node.add_child(new_interactable)
		
	
	for enemy in room_data.enemies:
		if not enemy.dead:
			var enemy_scene = load(enemy.scene_path)
			var new_enemy = enemy_scene.instantiate()
			new_enemy.enemy_data = enemy
			
			new_enemy.load_enemy()
			enemy_parent.add_child(new_enemy)