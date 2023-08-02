extends CharacterBody2D

var screen_size:Vector2
var rng = RandomNumberGenerator.new()
var direction:Vector2 = Vector2.ZERO
var speed:int = 400

@export var min_speed:int = 400
@export var max_speed:int = 1200

signal screen_exited_left
signal screen_exited_right

# Called when the node enters the scene tree for the first time.
func _ready():
	speed = min_speed
	screen_size = get_viewport_rect().size
	set_random_direction()

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

func _on_visible_on_screen_notifier_2d_screen_exited():
	var old_position:Vector2 = position
	position = Vector2(screen_size.x/2, screen_size.y/2)
	speed = min_speed
	set_random_direction()
	
	# send signal about who missed the ball
	if old_position.x < position.x:
		screen_exited_left.emit()
	else:
		screen_exited_right.emit()
