extends CharacterBody2D


# VARIABLES

@export var upAction:String = "up"
@export var downAction:String = "down"

@onready var shape:RectangleShape2D = $CollisionShape2D.shape
@onready var sprite:Sprite2D = $Sprite2D
# used to lock x position
@onready var x_pos = self.position.x

var height:int
var speed:int


# SIGNALS


# FUNCTIONS

func _set_settings_from_global():
	speed = GlobalSettings.data.Global.paddle_speed * 100
	height = GlobalSettings.data.Global.paddle_height * 10
	shape.size.y = height
	sprite.scale.y = height


func _ready():
	_set_settings_from_global()


func get_input():
	var direction = Input.get_axis(upAction, downAction)
	velocity = Vector2(0, direction * speed)


func _physics_process(delta):
	get_input()
	# lock x position
	position.x = x_pos
	
	# handle collision when moving up & down
	# for example when the paddle is colliding with the ball
	var collision:KinematicCollision2D = move_and_collide(velocity * delta)
	if collision:
		var collider:Object = collision.get_collider()
		if collider.has_method("handle_collision"):
			collider.handle_collision(self)


func ball_speed_after_bounce(min_speed:float, max_speed:float, ball_position:Vector2) -> float:
	# how far from the center in y-axis was the hit?
	var from_center:float = ball_position.y - position.y
	# normalizing from_center (20 to -20 range -> 1 to -1 range)
	# that's done by dividing from_center with max value (in this case: height / 2)
	var from_center_normalized:float = from_center / (height / 2)
	# convert from_center_normalized to speed_multiplyer by converting value to absolute (force positive)
	var speed_multiplyer = abs(from_center_normalized)
	# get the speed range
	var speed_range = max_speed - min_speed
	# min_speed is always included, and then add the speed_range multiplied with the multiplyer
	return min_speed + (speed_range * speed_multiplyer)


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

func _on_settings_paddle_changed():
	_set_settings_from_global()
