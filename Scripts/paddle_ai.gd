extends Node2D
class_name PaddleAI

var side:String
var ball_position:Vector2 = Vector2.ZERO
var ball_velocity:Vector2 = Vector2.ZERO

func _ready():
	var screen_size = get_viewport_rect().size
	var center:Vector2 = Vector2(screen_size.x/2, screen_size.y/2)
	side = 'left' if position.x < center.x else 'right'

func get_direction(AI:int) -> int:
	if AI == 1:
		return easy_ai()
	if AI == 2:
		return hard_ai()
	if AI == 3:
		return impossible_ai()
	return 0

func easy_ai() -> int:
	# ignore the ball if it is going away from the paddle
	if side == 'left' and ball_velocity.x < 0:
		return 0
	if side == 'right' and ball_velocity.x > 0:
		return 0
	
	if global_position.y > ball_position.y:
		return -1
	if global_position.y < ball_position.y:
		return 1
	
	return 0

func hard_ai():
	return 0

func impossible_ai():
	return 0
