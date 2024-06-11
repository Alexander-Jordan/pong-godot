extends CharacterBody2D

# VARIABLES

@export_range(1, 2, 1) var player:int
@export var upAction:String = "up"
@export var downAction:String = "down"

@onready var collision_shape:CollisionShape2D = $CollisionShape2D
@onready var sprite:Sprite2D = $Sprite2D
@onready var paddle_ai:PaddleAI = $PaddleAI
# used to lock x position
@onready var x_pos = self.position.x

var height:int
var speed:int
var ai:int

# SIGNALS

# FUNCTIONS

func set_settings_from_global():
	var settings:Dictionary = GlobalSettings.data.paddles['paddle_{player}'.format({'player': player})].templates.custom
	speed = settings.paddle_speed * 100
	height = settings.paddle_height * 10
	var shape = RectangleShape2D.new()
	shape.size = Vector2(10, height)
	collision_shape.set_shape(shape)
	sprite.scale.y = height

func set_ai_from_global_type():
	var type = GlobalSettings.data.paddles['paddle_{player}'.format({'player': player})].type
	if type is int:
		ai = type

func _ready():
	set_settings_from_global()
	set_ai_from_global_type()

func get_input():
	var direction = Input.get_axis(upAction, downAction) if ai == 0 else paddle_ai.get_direction(ai)
	velocity = Vector2(0, direction * speed)

func _physics_process(delta):
	get_input()
	# lock x position
	position.x = x_pos
	move_and_collide(velocity * delta)

func increase_ball_speed_after_bounce(ball_speed:float, min_increase:float, max_speed:float, ball_position:Vector2) -> float:
	# first check if the current speed has already reached the limit
	if ball_speed >= max_speed:
		return ball_speed
	
	# how far from the center in y-axis was the hit?
	var from_center:float = ball_position.y - position.y
	# normalizing from_center (20 to -20 range -> 1 to -1 range)
	# that's done by dividing from_center with max value (in this case: height / 2)
	var from_center_normalized:float = from_center / (height / 2)
	# convert from_center_normalized to speed_multiplyer by converting value to absolute (force positive)
	var speed_multiplyer = abs(from_center_normalized)
	# min_increase is always included, and then add the increase multiplied with the multiplyer
	return (ball_speed + min_increase) + (min_increase * speed_multiplyer)

func ball_velocity_after_bounce(ball_velocity:Vector2, ball_position:Vector2) -> Vector2:
	# new x should be:
	# - negative if the ball on impact is on the left side of the paddle
	# - positive if the ball on impact is on the right side of the paddle
	var new_x:float = -abs(ball_velocity.x) if ball_position.x <= position.x else abs(ball_velocity.x)
	# how far from the center in y-axis was the hit?
	var from_center:float = ball_position.y - position.y
	# new y is calculated by normalizing from_center (20 to -20 range -> 1 to -1 range)
	# that's done by dividing from_center with max value (in this case: height / 2)
	var new_y:float = from_center / (height / 2)
	# clamp new_y so it doesn't shoot straight up or down
	new_y = clampf(new_y, -0.9, 0.9)
	return Vector2(new_x, new_y).normalized()

# SIGNAL FUNCTIONS

func _on_settings_paddle_type_changed():
	set_ai_from_global_type()

func _on_settings_paddle_height_changed():
	var settings:Dictionary = GlobalSettings.data.paddles['paddle_{player}'.format({'player': player})].templates.custom
	height = settings.paddle_height * 10
	var shape = RectangleShape2D.new()
	shape.size = Vector2(10, height)
	collision_shape.set_shape(shape)
	sprite.scale.y = height

func _on_settings_paddle_speed_changed():
	var settings:Dictionary = GlobalSettings.data.paddles['paddle_{player}'.format({'player': player})].templates.custom
	speed = settings.paddle_speed * 100

func _on_ball_current_position(pos:Vector2):
	paddle_ai.ball_position = pos

func _on_ball_current_velocity(vel:Vector2):
	paddle_ai.ball_velocity = vel
