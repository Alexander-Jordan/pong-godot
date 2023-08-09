extends CharacterBody2D

var screen_size:Vector2
var rng = RandomNumberGenerator.new()
var direction:Vector2 = Vector2.ZERO
@onready var min_speed:int = GlobalSettings.data.Global.ball_min_speed * 100
@onready var max_speed:int = GlobalSettings.data.Global.ball_max_speed * 100
@onready var speed:int = min_speed

signal screen_exited_left
signal screen_exited_right

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	reset_ball_and_serve()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collision = move_and_collide(velocity * speed * delta)
	if collision:
		var collider:Object = collision.get_collider()
		if collider.has_method("increase_ball_speed_after_bounce"):
			speed = collider.increase_ball_speed_after_bounce(speed, 50, max_speed, position)
		elif collider.has_method("ball_speed_after_bounce"):
			speed = collider.ball_speed_after_bounce(min_speed, max_speed, position)
		if collider.has_method("ball_velocity_after_bounce"):
			velocity = collider.ball_velocity_after_bounce(velocity, position)
		else:
			velocity = velocity.bounce(collision.get_normal())

func set_random_direction():
	var zero_or_one = rng.randi_range(0, 1)
	direction = Vector2(-1 if zero_or_one == 0 else 1, rng.randf_range(-1, 1))
	velocity = direction.normalized()

func reset_ball_and_serve():
	position = Vector2(screen_size.x/2, screen_size.y/2)
	speed = min_speed
	set_random_direction()

func _on_visible_on_screen_notifier_2d_screen_exited():
	# send signal about who missed the ball
	if position.x < (screen_size.x/2):
		screen_exited_left.emit()
	else:
		screen_exited_right.emit()

func _on_game_manager_new_serve():
	reset_ball_and_serve()
