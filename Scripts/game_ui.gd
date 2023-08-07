extends Control

func _on_game_manager_game_reset():
	$Score/PlayerOne.text = "0"
	$Score/PlayerTwo.text = "0"
	$GameOver.visible = false


func _on_game_manager_point_change(target:String, new_total_points:int):
	if target == "player_one":
		$Score/PlayerOne.text = str(new_total_points)
	elif target == "player_two":
		$Score/PlayerTwo.text = str(new_total_points)


func _on_game_manager_game_over():
	$GameOver.visible = true
