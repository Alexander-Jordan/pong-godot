extends Node2D
class_name GameManager

signal pause_game
signal unpause_game

func toggle_pause():
	var paused = !get_tree().paused
	get_tree().paused = paused
	
	if paused:
		pause_game.emit()
	else:
		unpause_game.emit()

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause()

func _on_continue_button_pressed():
	toggle_pause()

func _on_restart_button_pressed():
	toggle_pause()
	get_tree().change_scene_to_file("res://Scenes/Levels/main.tscn")

func _on_exit_button_pressed():
	toggle_pause()
	get_tree().change_scene_to_file("res://Scenes/Levels/menu.tscn")
