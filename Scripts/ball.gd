extends Area2D

var rng = RandomNumberGenerator.new()

@export var speed:int = 400
var direction:Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	set_random_direction()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if direction.length() > 0:
		direction = direction.normalized() * speed
	
	position += direction * delta

func set_random_direction():
	var zero_or_one = rng.randi_range(0, 1)
	direction = Vector2(-1 if zero_or_one == 0 else 1, rng.randf_range(-1, 1))
