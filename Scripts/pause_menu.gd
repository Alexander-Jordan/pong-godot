extends Control

func _on_game_manager_game_pause():
	$VBoxContainer/ContinueButton.grab_focus()
	visible = true

func _on_game_manager_game_unpause():
	visible = false
