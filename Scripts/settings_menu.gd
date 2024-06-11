extends Window

# PADDLE 1

@onready var paddle_1_template_option_button = $TabContainer/Paddles/Paddle1/VBoxContainer/Template/OptionButton
@onready var paddle_1_type_option_button = $TabContainer/Paddles/Paddle1/VBoxContainer/Type/OptionButton
@onready var paddle_1_height_value = $TabContainer/Paddles/Paddle1/VBoxContainer/Height/VBoxContainer/Label
@onready var paddle_1_height_slider = $TabContainer/Paddles/Paddle1/VBoxContainer/Height/VBoxContainer/Slider
@onready var paddle_1_speed_value = $TabContainer/Paddles/Paddle1/VBoxContainer/Speed/VBoxContainer/Label
@onready var paddle_1_speed_slider = $TabContainer/Paddles/Paddle1/VBoxContainer/Speed/VBoxContainer/Slider

# PADDLE 2

@onready var paddle_2_template_option_button = $TabContainer/Paddles/Paddle2/VBoxContainer/Template/OptionButton
@onready var paddle_2_type_option_button = $TabContainer/Paddles/Paddle2/VBoxContainer/Type/OptionButton
@onready var paddle_2_height_value = $TabContainer/Paddles/Paddle2/VBoxContainer/Height/VBoxContainer/Label
@onready var paddle_2_height_slider = $TabContainer/Paddles/Paddle2/VBoxContainer/Height/VBoxContainer/Slider
@onready var paddle_2_speed_value = $TabContainer/Paddles/Paddle2/VBoxContainer/Speed/VBoxContainer/Label
@onready var paddle_2_speed_slider = $TabContainer/Paddles/Paddle2/VBoxContainer/Speed/VBoxContainer/Slider

# BALL

@onready var ball_template_option_button = $TabContainer/Ball/VBoxContainer/Template/OptionButton
@onready var ball_size_value = $TabContainer/Ball/VBoxContainer/Size/VBoxContainer/Label
@onready var ball_size_slider = $TabContainer/Ball/VBoxContainer/Size/VBoxContainer/Slider
@onready var ball_min_speed_value = $TabContainer/Ball/VBoxContainer/MinSpeed/VBoxContainer/Label
@onready var ball_min_speed_slider = $TabContainer/Ball/VBoxContainer/MinSpeed/VBoxContainer/Slider
@onready var ball_max_speed_value = $TabContainer/Ball/VBoxContainer/MaxSpeed/VBoxContainer/Label
@onready var ball_max_speed_slider = $TabContainer/Ball/VBoxContainer/MaxSpeed/VBoxContainer/Slider
@onready var ball_speed_increase_value = $TabContainer/Ball/VBoxContainer/SpeedIncrease/VBoxContainer/Label
@onready var ball_speed_increase_slider = $TabContainer/Ball/VBoxContainer/SpeedIncrease/VBoxContainer/Slider

signal paddle_1_type_changed
signal paddle_1_height_changed
signal paddle_1_speed_changed
signal paddle_2_type_changed
signal paddle_2_height_changed
signal paddle_2_speed_changed
signal ball_size_changed
signal ball_min_speed_changed
signal ball_max_speed_changed
signal ball_speed_increase_changed

func _on_settings_button_pressed():
	self.show()

func _ready():
	setup_paddles_signal_connections()
	setup_ball_signal_connections()
	
	set_paddle_1_settings_from_global_settings(true)
	set_paddle_2_settings_from_global_settings(true)
	set_ball_settings_from_global_settings(true)

func select_option_item_from_name(option_button:OptionButton, target_name:String):
	for item_index in option_button.item_count:
		var item_name = option_button.get_item_text(item_index).to_lower()
		if item_name == target_name:
			option_button.select(item_index)
			break

func set_paddle_1_settings_from_global_settings(init:bool):
	var settings:Dictionary = GlobalSettings.data.paddles.paddle_1
	
	if init:
		# select type option
		paddle_1_type_option_button.select(settings.type)
		# select template option
		select_option_item_from_name(paddle_1_template_option_button, settings.current_template)
	
	# get custom (current) settings
	var custom_settings = settings.templates.custom
	
	# set UI element
	paddle_1_height_slider.value = custom_settings.paddle_height
	paddle_1_height_value.text = str(custom_settings.paddle_height)
	paddle_1_speed_slider.value = custom_settings.paddle_speed
	paddle_1_speed_value.text = str(custom_settings.paddle_speed)

func set_paddle_2_settings_from_global_settings(init:bool):
	var settings:Dictionary = GlobalSettings.data.paddles.paddle_2
	
	if init:
		# select type option
		paddle_2_type_option_button.select(settings.type)
		# select template option
		select_option_item_from_name(paddle_2_template_option_button, settings.current_template)
	
	# get custom (current) settings
	var custom_settings = settings.templates.custom
	
	# set UI element
	paddle_2_height_slider.value = custom_settings.paddle_height
	paddle_2_height_value.text = str(custom_settings.paddle_height)
	paddle_2_speed_slider.value = custom_settings.paddle_speed
	paddle_2_speed_value.text = str(custom_settings.paddle_speed)

func set_ball_settings_from_global_settings(init:bool):
	var settings:Dictionary = GlobalSettings.data.ball
	
	if init:
		# select template option
		select_option_item_from_name(ball_template_option_button, settings.current_template)
	
	# get custom (current) settings
	var custom_settings = settings.templates.custom
	
	# set UI element
	ball_size_slider.value = custom_settings.ball_size
	ball_size_value.text = str(custom_settings.ball_size)
	ball_min_speed_slider.value = custom_settings.ball_min_speed
	ball_min_speed_value.text = str(custom_settings.ball_min_speed)
	ball_max_speed_slider.value = custom_settings.ball_max_speed
	ball_max_speed_value.text = str(custom_settings.ball_max_speed)
	ball_speed_increase_slider.value = custom_settings.ball_speed_increase
	ball_speed_increase_value.text = str(custom_settings.ball_speed_increase)

func setup_paddles_signal_connections():
	# PADDLE 1
	paddle_1_template_option_button.connect('item_selected', _on_paddle_1_template_option_button_item_selected)
	paddle_1_type_option_button.connect('item_selected', _on_paddle_1_type_option_button_item_selected)
	paddle_1_height_slider.connect('drag_ended', on_paddle_1_settings_slider_drag_ended)
	paddle_1_height_slider.connect('value_changed', _on_paddle_1_height_slider_value_changed)
	paddle_1_speed_slider.connect('drag_ended', on_paddle_1_settings_slider_drag_ended)
	paddle_1_speed_slider.connect('value_changed', _on_paddle_1_speed_slider_value_changed)
	
	# PADDLE 2
	paddle_2_template_option_button.connect('item_selected', _on_paddle_2_template_option_button_item_selected)
	paddle_2_type_option_button.connect('item_selected', _on_paddle_2_type_option_button_item_selected)
	paddle_2_height_slider.connect('drag_ended', on_paddle_2_settings_slider_drag_ended)
	paddle_2_height_slider.connect('value_changed', _on_paddle_2_height_slider_value_changed)
	paddle_2_speed_slider.connect('drag_ended', on_paddle_2_settings_slider_drag_ended)
	paddle_2_speed_slider.connect('value_changed', _on_paddle_2_speed_slider_value_changed)

func setup_ball_signal_connections():
	ball_template_option_button.connect('item_selected', _on_ball_template_option_button_item_selected)
	ball_size_slider.connect('drag_ended', on_ball_settings_slider_drag_ended)
	ball_min_speed_slider.connect('drag_ended', on_ball_settings_slider_drag_ended)
	ball_max_speed_slider.connect('drag_ended', on_ball_settings_slider_drag_ended)
	ball_speed_increase_slider.connect('drag_ended', on_ball_settings_slider_drag_ended)
	ball_size_slider.connect('value_changed', _on_ball_size_slider_value_changed)
	ball_min_speed_slider.connect('value_changed', _on_ball_min_speed_slider_value_changed)
	ball_max_speed_slider.connect('value_changed', _on_ball_max_speed_slider_value_changed)
	ball_speed_increase_slider.connect('value_changed', _on_ball_speed_increase_slider_value_changed)

func _on_paddle_1_template_option_button_item_selected(index):
	var paddle_1_settings:Dictionary = GlobalSettings.data.paddles.paddle_1
	var template_name = paddle_1_template_option_button.get_item_text(index).to_lower()
	if paddle_1_settings.templates.has(template_name):
		paddle_1_settings.current_template = template_name
		paddle_1_settings.templates.custom = paddle_1_settings.templates.get(template_name).duplicate(true)
		set_paddle_1_settings_from_global_settings(false)

func _on_paddle_2_template_option_button_item_selected(index):
	var paddle_2_settings:Dictionary = GlobalSettings.data.paddles.paddle_2
	var template_name = paddle_2_template_option_button.get_item_text(index).to_lower()
	if paddle_2_settings.templates.has(template_name):
		paddle_2_settings.current_template = template_name
		paddle_2_settings.templates.custom = paddle_2_settings.templates.get(template_name).duplicate(true)
		set_paddle_2_settings_from_global_settings(false)

func _on_ball_template_option_button_item_selected(index):
	var ball_settings:Dictionary = GlobalSettings.data.ball
	var template_name = ball_template_option_button.get_item_text(index).to_lower()
	if ball_settings.templates.has(template_name):
		ball_settings.current_template = template_name
		ball_settings.templates.custom = ball_settings.templates.get(template_name).duplicate(true)
		set_ball_settings_from_global_settings(false)

func _on_paddle_1_type_option_button_item_selected(index):
	GlobalSettings.data.paddles.paddle_1.type = index
	paddle_1_type_changed.emit()

func _on_paddle_2_type_option_button_item_selected(index):
	GlobalSettings.data.paddles.paddle_2.type = index
	paddle_2_type_changed.emit()

func on_paddle_1_settings_slider_drag_ended(value_changed:bool):
	if value_changed:
		# set current template to 'custom'
		select_option_item_from_name(paddle_1_template_option_button, 'custom')
		# set it in Global Settings as well
		GlobalSettings.data.paddles.paddle_1.current_template = 'custom'

func on_paddle_2_settings_slider_drag_ended(value_changed:bool):
	if value_changed:
		# set current template to 'custom'
		select_option_item_from_name(paddle_2_template_option_button, 'custom')
		# set it in Global Settings as well
		GlobalSettings.data.paddles.paddle_2.current_template = 'custom'

func _on_paddle_1_height_slider_value_changed(value:float):
	paddle_1_height_value.text = str(int(value))
	GlobalSettings.data.paddles.paddle_1.templates.custom.paddle_height = int(value)
	paddle_1_height_changed.emit()

func _on_paddle_2_height_slider_value_changed(value:float):
	paddle_2_height_value.text = str(int(value))
	GlobalSettings.data.paddles.paddle_2.templates.custom.paddle_height = int(value)
	paddle_2_height_changed.emit()

func _on_paddle_1_speed_slider_value_changed(value:float):
	paddle_1_speed_value.text = str(int(value))
	GlobalSettings.data.paddles.paddle_1.templates.custom.paddle_speed = int(value)
	paddle_1_speed_changed.emit()

func _on_paddle_2_speed_slider_value_changed(value:float):
	paddle_2_speed_value.text = str(int(value))
	GlobalSettings.data.paddles.paddle_2.templates.custom.paddle_speed = int(value)
	paddle_2_speed_changed.emit()

func on_ball_settings_slider_drag_ended(value_changed:bool):
	if value_changed:
		# set current template to 'custom'
		select_option_item_from_name(ball_template_option_button, 'custom')
		# set it in Global Settings as well
		GlobalSettings.data.ball.current_template = 'custom'

func _on_ball_size_slider_value_changed(value:float):
	ball_size_value.text = str(int(value))
	GlobalSettings.data.ball.templates.custom.ball_size = int(value)
	ball_size_changed.emit()

func _on_ball_min_speed_slider_value_changed(value:float):
	ball_min_speed_value.text = str(int(value))
	GlobalSettings.data.ball.templates.custom.ball_min_speed = int(value)
	if value > GlobalSettings.data.ball.templates.custom.ball_max_speed:
		ball_max_speed_slider.value = int(value)
	ball_min_speed_changed.emit()

func _on_ball_max_speed_slider_value_changed(value:float):
	ball_max_speed_value.text = str(int(value))
	GlobalSettings.data.ball.templates.custom.ball_max_speed = int(value)
	if value < GlobalSettings.data.ball.templates.custom.ball_min_speed:
		ball_min_speed_slider.value = int(value)
	ball_max_speed_changed.emit()

func _on_ball_speed_increase_slider_value_changed(value:float):
	ball_speed_increase_value.text = str(int(value))
	GlobalSettings.data.ball.templates.custom.ball_speed_increase = int(value)
	ball_speed_increase_changed.emit()

func _on_close_requested():
	GlobalSettings.save_data()
	self.hide()
