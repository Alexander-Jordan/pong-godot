extends Node

@onready var visuals_background_option_button:OptionButton = $TabContainer/Visuals/GridContainer/Background/OptionButton
@onready var visuals_paddles_option_button:OptionButton = $TabContainer/Visuals/GridContainer/Paddles/OptionButton
@onready var visuals_ball_option_button:OptionButton = $TabContainer/Visuals/GridContainer/Ball/OptionButton

@onready var paddle_speed_value = $TabContainer/Paddle/GridContainer/PaddleSpeed/Controller/Value
@onready var paddle_speed_slider = $TabContainer/Paddle/GridContainer/PaddleSpeed/Controller/Slider

@onready var paddle_height_value = $TabContainer/Paddle/GridContainer/PaddleHeight/Controller/Value
@onready var paddle_height_slider = $TabContainer/Paddle/GridContainer/PaddleHeight/Controller/Slider

@onready var ball_size_value = $TabContainer/Ball/GridContainer/BallSize/Controller/Value
@onready var ball_size_slider = $TabContainer/Ball/GridContainer/BallSize/Controller/Slider

@onready var ball_min_speed_value = $TabContainer/Ball/GridContainer/BallMinSpeed/Controller/Value
@onready var ball_min_speed_slider = $TabContainer/Ball/GridContainer/BallMinSpeed/Controller/Slider

@onready var ball_max_speed_value = $TabContainer/Ball/GridContainer/BallMaxSpeed/Controller/Value
@onready var ball_max_speed_slider = $TabContainer/Ball/GridContainer/BallMaxSpeed/Controller/Slider

@onready var ball_speed_increase_value = $TabContainer/Ball/GridContainer/BallSpeedIncrease/Controller/Value
@onready var ball_speed_increase_slider = $TabContainer/Ball/GridContainer/BallSpeedIncrease/Controller/Slider

signal visuals_changed
signal paddle_changed
signal ball_changed

func _on_settings_button_pressed():
	self.visible = true

func _ready():
	var visuals_settings:Dictionary = GlobalSettings.data.visuals.current
	var gameplay_settings:Dictionary = GlobalSettings.data.gameplays.current
	
	visuals_background_option_button.grab_focus()
	visuals_background_option_button.select(visuals_settings.background)
	
	visuals_paddles_option_button.grab_focus()
	visuals_paddles_option_button.select(visuals_settings.paddles)
	
	visuals_ball_option_button.grab_focus()
	visuals_ball_option_button.select(visuals_settings.ball)
	
	paddle_speed_value.text = str(gameplay_settings.paddle_speed)
	paddle_speed_slider.value = gameplay_settings.paddle_speed
	
	paddle_height_value.text = str(gameplay_settings.paddle_height)
	paddle_height_slider.value = gameplay_settings.paddle_height
	
	ball_size_value.text = str(gameplay_settings.ball_size)
	ball_size_slider.value = gameplay_settings.ball_size
	
	ball_min_speed_value.text = str(gameplay_settings.ball_min_speed)
	ball_min_speed_slider.value = gameplay_settings.ball_min_speed
	
	ball_max_speed_value.text = str(gameplay_settings.ball_max_speed)
	ball_max_speed_slider.value = gameplay_settings.ball_max_speed
	
	ball_speed_increase_value.text = str(gameplay_settings.ball_speed_increase)
	ball_speed_increase_slider.value = gameplay_settings.ball_speed_increase


func _on_visuals_background_option_button_item_selected(index):
	print(index)
	GlobalSettings.data.visuals.current.background = index
	visuals_changed.emit()


func _on_visuals_paddles_option_button_item_selected(index):
	GlobalSettings.data.visuals.current.paddles = index
	visuals_changed.emit()


func _on_visuals_ball_option_button_item_selected(index):
	GlobalSettings.data.visuals.current.ball = index
	visuals_changed.emit()


func _on_paddle_speed_slider_value_changed(value):
	paddle_speed_value.text = str(value)
	GlobalSettings.data.gameplays.current.paddle_speed = value
	paddle_changed.emit()


func _on_paddle_height_slider_value_changed(value):
	paddle_height_value.text = str(value)
	GlobalSettings.data.gameplays.current.paddle_height = value
	paddle_changed.emit()


func _on_ball_size_slider_value_changed(value):
	ball_size_value.text = str(value)
	GlobalSettings.data.gameplays.current.ball_size = value
	ball_changed.emit()


func _on_ball_min_speed_slider_value_changed(value):
	ball_min_speed_value.text = str(value)
	GlobalSettings.data.gameplays.current.ball_min_speed = value
	if value > GlobalSettings.data.gameplays.current.ball_max_speed:
		ball_max_speed_slider.value = value
	ball_changed.emit()


func _on_ball_max_speed_slider_value_changed(value):
	ball_max_speed_value.text = str(value)
	GlobalSettings.data.gameplays.current.ball_max_speed = value
	if value < GlobalSettings.data.gameplays.current.ball_min_speed:
		ball_min_speed_slider.value = value
	ball_changed.emit()


func _on_ball_speed_increase_slider_value_changed(value):
	ball_speed_increase_value.text = str(value)
	GlobalSettings.data.gameplays.current.ball_speed_increase = value
	ball_changed.emit()


func _on_settings_close():
	GlobalSettings.save_data()
