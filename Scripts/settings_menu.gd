extends Node

@onready var theme_option_button:OptionButton = $VBoxContainer/TabContainer/Graphics/GridContainer/Theme/OptionButton

@onready var paddle_speed_value = $VBoxContainer/TabContainer/Gameplay/GridContainer/PaddleSpeed/Controller/Value
@onready var paddle_speed_slider = $VBoxContainer/TabContainer/Gameplay/GridContainer/PaddleSpeed/Controller/Slider

@onready var ball_min_speed_value = $VBoxContainer/TabContainer/Gameplay/GridContainer/BallMinSpeed/Controller/Value
@onready var ball_min_speed_slider = $VBoxContainer/TabContainer/Gameplay/GridContainer/BallMinSpeed/Controller/Slider

@onready var ball_max_speed_value = $VBoxContainer/TabContainer/Gameplay/GridContainer/BallMaxSpeed/Controller/Value
@onready var ball_max_speed_slider = $VBoxContainer/TabContainer/Gameplay/GridContainer/BallMaxSpeed/Controller/Slider

@onready var ball_speed_increase_value = $VBoxContainer/TabContainer/Gameplay/GridContainer/BallSpeedIncrease/Controller/Value
@onready var ball_speed_increase_slider = $VBoxContainer/TabContainer/Gameplay/GridContainer/BallSpeedIncrease/Controller/Slider

func _ready():
	theme_option_button.grab_focus()
	theme_option_button.select(GlobalSettings.data.Global.theme)
	
	paddle_speed_value.text = str(GlobalSettings.data.Global.paddle_speed)
	paddle_speed_slider.value = GlobalSettings.data.Global.paddle_speed
	
	ball_min_speed_value.text = str(GlobalSettings.data.Global.ball_min_speed)
	ball_min_speed_slider.value = GlobalSettings.data.Global.ball_min_speed
	
	ball_max_speed_value.text = str(GlobalSettings.data.Global.ball_max_speed)
	ball_max_speed_slider.value = GlobalSettings.data.Global.ball_max_speed
	
	ball_speed_increase_value.text = str(GlobalSettings.data.Global.ball_speed_increase)
	ball_speed_increase_slider.value = GlobalSettings.data.Global.ball_speed_increase


func _on_theme_option_button_item_selected(index):
	GlobalSettings.data.Global.theme = index


func _on_paddle_speed_slider_value_changed(value):
	paddle_speed_value.text = str(value)
	GlobalSettings.data.Global.paddle_speed = value


func _on_ball_min_speed_slider_value_changed(value):
	ball_min_speed_value.text = str(value)
	GlobalSettings.data.Global.ball_min_speed = value
	if value > GlobalSettings.data.Global.ball_max_speed:
		ball_max_speed_slider.value = value


func _on_ball_max_speed_slider_value_changed(value):
	ball_max_speed_value.text = str(value)
	GlobalSettings.data.Global.ball_max_speed = value
	if value < GlobalSettings.data.Global.ball_min_speed:
		ball_min_speed_slider.value = value


func _on_ball_speed_increase_slider_value_changed(value):
	ball_speed_increase_value.text = str(value)
	GlobalSettings.data.Global.ball_speed_increase = value


func _on_save_button_pressed():
	GlobalSettings.save_data()
	self.visible = false
