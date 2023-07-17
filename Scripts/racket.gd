extends CharacterBody2D

@export var speed:int = 400
@export var upAction:String = "up"
@export var downAction:String = "down"

func get_input():
	var direction = Input.get_axis(upAction, downAction)
	velocity = Vector2(0, direction * speed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	get_input()
	move_and_collide(velocity * delta)

func ball_velocity_after_bounce(ball_velocity:Vector2) -> Vector2:
	# set new direction by flipping x
	var new_x_direction:float = -ball_velocity.x if sign(ball_velocity.x) == 1 else abs(ball_velocity.x)
	return Vector2(new_x_direction, ball_velocity.y)
