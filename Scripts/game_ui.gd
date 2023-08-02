extends Control

func _on_game_manager_game_reset():
	$PlayerOneScore.text = "0"
	$PlayerTwoScore.text = "0"


func _on_game_manager_point_change(target:String, new_total_points:int):
	if target == "player_one":
		$PlayerOneScore.text = str(new_total_points)
	elif target == "player_two":
		$PlayerTwoScore.text = str(new_total_points)
