extends CharacterBody2D

# temp variable used to prevent out of bounds
var screenSize

@export var speed = 400
@export var upAction := "up"
@export var downAction := "down"

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
