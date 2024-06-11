extends CharacterBody2D

# VARIABLES

@export var audio_wall_bounce:AudioStream
@export var audio_paddle_bounce:AudioStream
@export var audio_out:AudioStream

@onready var shape:RectangleShape2D = $CollisionShape2D.shape
@onready var sprite:Sprite2D = $Sprite2D
@onready var audio_player:AudioStreamPlayer2D = $AudioStreamPlayer2D

var screen_size:Vector2
var rng = RandomNumberGenerator.new()
var direction:Vector2 = Vector2.ZERO
var size:int
var min_speed:int
var max_speed:int
var increase_speed:int
var speed:int

# SIGNALS

signal screen_exited_left
signal screen_exited_right
signal current_position(pos:Vector2)
signal current_velocity(vel:Vector2)

# FUNCTIONS

func set_settings_from_global():
	var gameplay_settings:Dictionary = GlobalSettings.data.ball.templates.custom
	# SIZE
	size = gameplay_settings.ball_size * 10
	shape.size = Vector2(size, size)
	sprite.scale = Vector2(size, size)
	
	# SPEED
	min_speed = gameplay_settings.ball_min_speed * 100
	max_speed = gameplay_settings.ball_max_speed * 100
	if speed < min_speed:
		speed = min_speed
	if speed > max_speed:
		speed = max_speed
	increase_speed = gameplay_settings.ball_speed_increase * 10

func _ready():
	set_settings_from_global()
	screen_size = get_viewport_rect().size

func _physics_process(delta):
	current_position.emit(self.global_position)
	current_velocity.emit(self.velocity)
	
	var collision = move_and_collide(velocity * speed * delta)
	if collision:
		var collider:Object = collision.get_collider()
		if !handle_velocity_after_collision(collider):
			# if the velocity was not handled after collision, just bounce
			velocity = velocity.bounce(collision.get_normal())
		
		# what bounce sound should be played?
		if collider is StaticBody2D:
			audio_player.stream = audio_wall_bounce
		else:
			audio_player.stream = audio_paddle_bounce
		audio_player.play()

func set_random_direction():
	var zero_or_one = rng.randi_range(0, 1)
	direction = Vector2(-1 if zero_or_one == 0 else 1, rng.randf_range(-1, 1))
	velocity = direction.normalized()

func reset_ball_and_serve():
	position = Vector2(screen_size.x/2, screen_size.y/2)
	speed = min_speed
	set_random_direction()
	audio_player.stream = audio_wall_bounce
	audio_player.play()

func handle_velocity_after_collision(object:Object) -> bool:
	# first check if the speed should change
	if object.has_method("increase_ball_speed_after_bounce"):
		speed = object.increase_ball_speed_after_bounce(speed, increase_speed, max_speed, position)
	
	# then check if the velocity should be handled
	if object.has_method("ball_velocity_after_bounce"):
		velocity = object.ball_velocity_after_bounce(velocity, position)
		return true
	
	# returning false means that the velocity was not handled
	return false

# SIGNAL FUNCTIONS

func _on_settings_ball_size_changed():
	var settings:Dictionary = GlobalSettings.data.ball.templates.custom
	size = settings.ball_size * 10
	shape.size = Vector2(size, size)
	sprite.scale = Vector2(size, size)

func _on_settings_ball_min_speed_changed():
	var settings:Dictionary = GlobalSettings.data.ball.templates.custom
	min_speed = settings.ball_min_speed * 100
	if speed < min_speed:
		speed = min_speed

func _on_settings_ball_max_speed_changed():
	var settings:Dictionary = GlobalSettings.data.ball.templates.custom
	max_speed = settings.ball_max_speed * 100
	if speed > max_speed:
		speed = max_speed

func _on_settings_ball_speed_increase_changed():
	var settings:Dictionary = GlobalSettings.data.ball.templates.custom
	increase_speed = settings.ball_speed_increase * 10

func _on_visible_on_screen_notifier_2d_screen_exited():
	audio_player.stream = audio_out
	audio_player.play()
	
	# send signal about who missed the ball
	if position.x < (screen_size.x/2):
		screen_exited_left.emit()
	else:
		screen_exited_right.emit()

func _on_game_manager_new_serve():
	reset_ball_and_serve()
