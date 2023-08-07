extends StaticBody2D

func _ready():
	set_collision_layer_value(1, false)

func _on_game_manager_game_over():
	set_collision_layer_value(1, true)
