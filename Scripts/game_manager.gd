extends Node2D
class_name GameManager

var player_one_points:int = 0
var player_two_points:int = 0
var is_game_over:bool = false

signal new_serve
signal game_over
signal game_reset
signal game_pause
signal game_unpause
signal point_change

func ready():
	init_new_game()

func init_new_game():
	game_reset.emit()
	player_one_points = 0
	player_two_points = 0
	

func toggle_pause():
	get_tree().paused = !get_tree().paused
	# send signal
	if get_tree().paused:
		game_pause.emit()
	else:
		game_unpause.emit()

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause()
	if is_game_over && (Input.is_action_just_pressed("ui_accept") || Input.is_action_just_pressed("ui_cancel")):
		get_tree().change_scene_to_file("res://Scenes/Levels/menu.tscn")

func _on_continue_button_pressed():
	toggle_pause()

func _on_restart_button_pressed():
	toggle_pause()
	get_tree().change_scene_to_file("res://Scenes/Levels/main.tscn")

func _on_exit_button_pressed():
	toggle_pause()
	get_tree().change_scene_to_file("res://Scenes/Levels/menu.tscn")

func _on_ball_screen_exited_left():
	player_two_points += 1
	point_change.emit("player_two", player_two_points)
	# wait for some time before doing anything else
	await get_tree().create_timer(2.0).timeout
	if player_two_points > 10:
		game_over.emit()
		is_game_over = true
	else:
		new_serve.emit()

func _on_ball_screen_exited_right():
	player_one_points += 1
	point_change.emit("player_one", player_one_points)
	# wait for some time before doing anything else
	await get_tree().create_timer(2.0).timeout
	if player_two_points > 10:
		game_over.emit()
		is_game_over = true
	else:
		new_serve.emit()
