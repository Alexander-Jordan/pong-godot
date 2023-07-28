extends Control

func _on_game_manager_pause_game():
	$VBoxContainer/ContinueButton.grab_focus()
	visible = true

func _on_game_manager_unpause_game():
	visible = false
