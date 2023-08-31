extends Node

@onready var visuals_background_option_button:OptionButton = $TabContainer/Visuals/GridContainer/Background/OptionButton
@onready var visuals_paddles_option_button:OptionButton = $TabContainer/Visuals/GridContainer/Paddles/OptionButton
@onready var visuals_ball_option_button:OptionButton = $TabContainer/Visuals/GridContainer/Ball/OptionButton

@onready var gameplay_general_template_option_button:OptionButton = $TabContainer/Gameplay/General/GridContainer/Template/OptionButton

@onready var paddle_speed_value = $TabContainer/Gameplay/Paddle/GridContainer/PaddleSpeed/Controller/Value
@onready var paddle_speed_slider = $TabContainer/Gameplay/Paddle/GridContainer/PaddleSpeed/Controller/Slider

@onready var paddle_height_value = $TabContainer/Gameplay/Paddle/GridContainer/PaddleHeight/Controller/Value
@onready var paddle_height_slider = $TabContainer/Gameplay/Paddle/GridContainer/PaddleHeight/Controller/Slider

@onready var ball_size_value = $TabContainer/Gameplay/Ball/GridContainer/BallSize/Controller/Value
@onready var ball_size_slider = $TabContainer/Gameplay/Ball/GridContainer/BallSize/Controller/Slider

@onready var ball_min_speed_value = $TabContainer/Gameplay/Ball/GridContainer/BallMinSpeed/Controller/Value
@onready var ball_min_speed_slider = $TabContainer/Gameplay/Ball/GridContainer/BallMinSpeed/Controller/Slider

@onready var ball_max_speed_value = $TabContainer/Gameplay/Ball/GridContainer/BallMaxSpeed/Controller/Value
@onready var ball_max_speed_slider = $TabContainer/Gameplay/Ball/GridContainer/BallMaxSpeed/Controller/Slider

@onready var ball_speed_increase_value = $TabContainer/Gameplay/Ball/GridContainer/BallSpeedIncrease/Controller/Value
@onready var ball_speed_increase_slider = $TabContainer/Gameplay/Ball/GridContainer/BallSpeedIncrease/Controller/Slider

signal visuals_changed
signal paddle_changed
signal ball_changed

func _on_settings_button_pressed():
	self.visible = true

func _ready():
	var template_settings:Dictionary = GlobalSettings.data.templates
	var visuals_settings:Dictionary = GlobalSettings.data.visuals.custom
	var gameplay_settings:Dictionary = GlobalSettings.data.gameplays.custom
	
	visuals_background_option_button.grab_focus()
	visuals_background_option_button.select(visuals_settings.background)
	
	visuals_paddles_option_button.grab_focus()
	visuals_paddles_option_button.select(visuals_settings.paddles)
	
	visuals_ball_option_button.grab_focus()
	visuals_ball_option_button.select(visuals_settings.ball)
	
	# generate gameplay template options from GlobalSettings
	var gameplay_template_idx:int = 0
	for gameplay in GlobalSettings.data.gameplays:
		gameplay_general_template_option_button.add_item(gameplay, gameplay_template_idx)
		# select the proper option item from GlobalSettings
		if template_settings.gameplay == gameplay_template_idx:
			gameplay_general_template_option_button.select(gameplay_template_idx)
		gameplay_template_idx = gameplay_template_idx + 1
	
	set_gameplay_settings_from_global_settings()

func set_gameplay_settings_from_global_settings():
	var gameplay_settings:Dictionary = GlobalSettings.data.gameplays.custom
	
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

func on_gameplay_setting_slider_drag_ended(value_changed:bool):
	if value_changed:
		# select "Custom" gameplay template
		gameplay_general_template_option_button.select(0)
		# set in Global Settings as well
		GlobalSettings.data.templates.gameplay = 0


func _on_visuals_background_option_button_item_selected(index):
	GlobalSettings.data.visuals.custom.background = index
	visuals_changed.emit()


func _on_visuals_paddles_option_button_item_selected(index):
	GlobalSettings.data.visuals.custom.paddles = index
	visuals_changed.emit()


func _on_visuals_ball_option_button_item_selected(index):
	GlobalSettings.data.visuals.custom.ball = index
	visuals_changed.emit()


func _on_gameplay_template_option_button_item_selected(index):
	GlobalSettings.data.templates.gameplay = index
	var gameplay_template_name = gameplay_general_template_option_button.get_item_text(index)
	if GlobalSettings.data.gameplays.has(gameplay_template_name):
		GlobalSettings.data.gameplays.custom = GlobalSettings.data.gameplays.get(gameplay_template_name).duplicate(true)
		set_gameplay_settings_from_global_settings()


func _on_paddle_height_slider_drag_ended(value_changed):
	on_gameplay_setting_slider_drag_ended(value_changed)
func _on_paddle_height_slider_value_changed(value):
	paddle_height_value.text = str(value)
	GlobalSettings.data.gameplays.custom.paddle_height = value
	paddle_changed.emit()


func _on_paddle_speed_slider_drag_ended(value_changed):
	on_gameplay_setting_slider_drag_ended(value_changed)
func _on_paddle_speed_slider_value_changed(value):
	paddle_speed_value.text = str(value)
	GlobalSettings.data.gameplays.custom.paddle_speed = value
	paddle_changed.emit()


func _on_ball_size_slider_drag_ended(value_changed):
	on_gameplay_setting_slider_drag_ended(value_changed)
func _on_ball_size_slider_value_changed(value):
	ball_size_value.text = str(value)
	GlobalSettings.data.gameplays.custom.ball_size = value
	ball_changed.emit()


func _on_ball_min_speed_slider_drag_ended(value_changed):
	on_gameplay_setting_slider_drag_ended(value_changed)
func _on_ball_min_speed_slider_value_changed(value):
	ball_min_speed_value.text = str(value)
	GlobalSettings.data.gameplays.custom.ball_min_speed = value
	if value > GlobalSettings.data.gameplays.custom.ball_max_speed:
		ball_max_speed_slider.value = value
	ball_changed.emit()


func _on_ball_max_speed_slider_drag_ended(value_changed):
	on_gameplay_setting_slider_drag_ended(value_changed)
func _on_ball_max_speed_slider_value_changed(value):
	ball_max_speed_value.text = str(value)
	GlobalSettings.data.gameplays.custom.ball_max_speed = value
	if value < GlobalSettings.data.gameplays.custom.ball_min_speed:
		ball_min_speed_slider.value = value
	ball_changed.emit()


func _on_ball_speed_increase_slider_drag_ended(value_changed):
	on_gameplay_setting_slider_drag_ended(value_changed)
func _on_ball_speed_increase_slider_value_changed(value):
	ball_speed_increase_value.text = str(value)
	GlobalSettings.data.gameplays.custom.ball_speed_increase = value
	ball_changed.emit()


func _on_settings_close():
	GlobalSettings.save_data()
