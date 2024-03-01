extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func start_fight(enemy_sprite):
	enemy_sprite.show()
	Ui.toggle_element(Ui.interaction_button_bar)
