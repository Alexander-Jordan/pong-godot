extends Node

@onready var theme_option_button:OptionButton = $TabContainer/Graphics/GridContainer/Theme/OptionButton

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

signal theme_changed
signal paddle_changed
signal ball_changed

func _on_settings_button_pressed():
	self.visible = true

func _ready():
	theme_option_button.grab_focus()
	theme_option_button.select(GlobalSettings.data.Global.theme)
	
	paddle_speed_value.text = str(GlobalSettings.data.Global.paddle_speed)
	paddle_speed_slider.value = GlobalSettings.data.Global.paddle_speed
	
	paddle_height_value.text = str(GlobalSettings.data.Global.paddle_height)
	paddle_height_slider.value = GlobalSettings.data.Global.paddle_height
	
	ball_size_value.text = str(GlobalSettings.data.Global.ball_size)
	ball_size_slider.value = GlobalSettings.data.Global.ball_size
	
	ball_min_speed_value.text = str(GlobalSettings.data.Global.ball_min_speed)
	ball_min_speed_slider.value = GlobalSettings.data.Global.ball_min_speed
	
	ball_max_speed_value.text = str(GlobalSettings.data.Global.ball_max_speed)
	ball_max_speed_slider.value = GlobalSettings.data.Global.ball_max_speed
	
	ball_speed_increase_value.text = str(GlobalSettings.data.Global.ball_speed_increase)
	ball_speed_increase_slider.value = GlobalSettings.data.Global.ball_speed_increase


func _on_theme_option_button_item_selected(index):
	GlobalSettings.data.Global.theme = index
	theme_changed.emit()


func _on_paddle_speed_slider_value_changed(value):
	paddle_speed_value.text = str(value)
	GlobalSettings.data.Global.paddle_speed = value
	paddle_changed.emit()


func _on_paddle_height_slider_value_changed(value):
	paddle_height_value.text = str(value)
	GlobalSettings.data.Global.paddle_height = value
	paddle_changed.emit()


func _on_ball_size_slider_value_changed(value):
	ball_size_value.text = str(value)
	GlobalSettings.data.Global.ball_size = value
	ball_changed.emit()


func _on_ball_min_speed_slider_value_changed(value):
	ball_min_speed_value.text = str(value)
	GlobalSettings.data.Global.ball_min_speed = value
	if value > GlobalSettings.data.Global.ball_max_speed:
		ball_max_speed_slider.value = value
	ball_changed.emit()


func _on_ball_max_speed_slider_value_changed(value):
	ball_max_speed_value.text = str(value)
	GlobalSettings.data.Global.ball_max_speed = value
	if value < GlobalSettings.data.Global.ball_min_speed:
		ball_min_speed_slider.value = value
	ball_changed.emit()


func _on_ball_speed_increase_slider_value_changed(value):
	ball_speed_increase_value.text = str(value)
	GlobalSettings.data.Global.ball_speed_increase = value
	ball_changed.emit()


func _on_settings_close():
	GlobalSettings.save_data()
