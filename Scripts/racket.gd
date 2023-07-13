extends CharacterBody2D

# temp variable used to prevent out of bounds
var screenSize:Vector2

@export var speed:int = 400
@export var upAction:String = "up"
@export var downAction:String = "down"

# Called when the node enters the scene tree for the first time.
func _ready():
	# get screen size to prevent racket to go out of bounds
	screenSize = get_viewport_rect().size

func get_input():
	var direction = Input.get_axis(upAction, downAction)
	velocity = Vector2(0, direction * speed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	get_input()
	move_and_slide()
	# simple temp constraint to prevent racket to move out of bounds
	position.y = clamp(position.y, 0, screenSize.y)

func set_new_ball_direction(current_position:Vector2, current_direction:Vector2) -> Vector2:
	# set new direction by flipping x direction
	var new_x_direction:float = -current_direction.x if sign(current_direction.x) == 1 else abs(current_direction.x)
	return Vector2(new_x_direction, current_direction.y)
