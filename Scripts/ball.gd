extends Area2D

var screen_size:Vector2
var rng = RandomNumberGenerator.new()

@export var speed:int = 400
var direction:Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	set_random_direction()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if direction.length() > 0:
		direction = direction.normalized() * speed
	
	if position.y < 0 || position.y > screen_size.y:
		bounce_off_wall()
	
	position += direction * delta

func set_random_direction():
	var zero_or_one = rng.randi_range(0, 1)
	direction = Vector2(-1 if zero_or_one == 0 else 1, rng.randf_range(-1, 1))

func bounce_off_wall():
	direction.y = -direction.y if sign(direction.y) == 1 else abs(direction.y)

func _on_visible_on_screen_notifier_2d_screen_exited():
	position = Vector2(screen_size.x/2, screen_size.y/2)
	set_random_direction()
