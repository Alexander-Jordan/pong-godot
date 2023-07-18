extends CharacterBody2D

@export var speed:int = 400
@export var upAction:String = "up"
@export var downAction:String = "down"

var size:Vector2 = Vector2.ZERO
var shape:RectangleShape2D

func _ready():
	shape = $CollisionShape2D.shape
	size = shape.size

func get_input():
	var direction = Input.get_axis(upAction, downAction)
	velocity = Vector2(0, direction * speed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	get_input()
	move_and_collide(velocity * delta)

func ball_speed_after_bounce(min_speed:float, max_speed:float, ball_position:Vector2) -> float:
	# how far from the center in y-axis was the hit?
	var from_center:float = ball_position.y - position.y
	# normalizing from_center (20 to -20 range -> 1 to -1 range)
	# that's done by dividing from_center with max value (in this case: height of collider / 2)
	var from_center_normalized:float = from_center / (size.y / 2)
	# convert from_center_normalized to speed_multiplyer by converting value to absolute (force positive)
	var speed_multiplyer = abs(from_center_normalized)
	# get the speed range
	var speed_range = max_speed - min_speed
	# min_speed is always included, and then add the speed_range multiplied with the multiplyer
	return min_speed + (speed_range * speed_multiplyer)

func ball_velocity_after_bounce(ball_velocity:Vector2, ball_position:Vector2) -> Vector2:
	# new x is simply x flipped
	var new_x:float = -ball_velocity.x if sign(ball_velocity.x) == 1 else abs(ball_velocity.x)
	# how far from the center in y-axis was the hit?
	var from_center:float = ball_position.y - position.y
	# new y is calculated by normalizing from_center (20 to -20 range -> 1 to -1 range)
	# that's done by dividing from_center with max value (in this case: height of collider / 2)
	var new_y:float = from_center / (size.y / 2)
	return Vector2(new_x, new_y).normalized()
