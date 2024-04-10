class_name RoomData
extends Resource

enum ROOM_NAMES {abandoned_cellar, abandoned_cellar_2}
@export var room_name: ROOM_NAMES
@export var interactables: Array[InteractableData]
@export var enemies: Array[EnemyData]
@export var current_scene: bool
# @export var scene_path: String
# @export var enemy_interactable_sprite: CompressedTexture2D
