extends Node2D
class_name PaddleAI

var center:Vector2
var side:String
var ball_position:Vector2 = Vector2.ZERO
var ball_velocity:Vector2 = Vector2.ZERO

func _ready():
	var screen_size = get_viewport_rect().size
	center = Vector2(screen_size.x/2, screen_size.y/2)
	side = 'left' if global_position.x < center.x else 'right'

func get_direction(AI:int) -> int:
	if AI == 1:
		return ai_type_1()
	if AI == 2:
		return ai_type_2()
	if AI == 3:
		return ai_type_3()
	return 0

func ai_type_1() -> int:
	# ignore the ball if it is going away from the paddle
	if is_ball_moving_away():
		return 0
	
	return keep_center_position_at_ball_center()

func ai_type_2() -> int:
	# move to the center if the ball is going away from the paddle
	if is_ball_moving_away():
		if global_position.y > center.y:
			return -1
		elif global_position.y < center.y:
			return 1
		else:
			return 0
	
	return keep_center_position_at_ball_center()

func ai_type_3() -> int:
	return keep_center_position_at_ball_center()

func keep_center_position_at_ball_center() -> int:
	if global_position.y > ball_position.y:
		return -1
	if global_position.y < ball_position.y:
		return 1
	
	return 0

func is_ball_moving_away():
	if side == 'left' and ball_velocity.x > 0:
		return true
	if side == 'right' and ball_velocity.x < 0:
		return true
	return false
