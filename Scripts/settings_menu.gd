extends Node

@onready var paddle_speed_value = $Control/GridContainer/PaddleSpeed/Controller/Value
@onready var paddle_speed_slider = $Control/GridContainer/PaddleSpeed/Controller/Slider

@onready var ball_min_speed_value = $Control/GridContainer/BallMinSpeed/Controller/Value
@onready var ball_min_speed_slider = $Control/GridContainer/BallMinSpeed/Controller/Slider

@onready var ball_max_speed_value = $Control/GridContainer/BallMaxSpeed/Controller/Value
@onready var ball_max_speed_slider = $Control/GridContainer/BallMaxSpeed/Controller/Slider

func _ready():
	paddle_speed_slider.grab_focus()
	
	paddle_speed_value.text = str(GlobalSettings.data.Global.paddle_speed)
	paddle_speed_slider.value = GlobalSettings.data.Global.paddle_speed
	
	ball_min_speed_value.text = str(GlobalSettings.data.Global.ball_min_speed)
	ball_min_speed_slider.value = GlobalSettings.data.Global.ball_min_speed
	
	ball_max_speed_value.text = str(GlobalSettings.data.Global.ball_max_speed)
	ball_max_speed_slider.value = GlobalSettings.data.Global.ball_max_speed


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


func _on_save_button_pressed():
	GlobalSettings.save_data()
	self.visible = false
