extends CharacterBody2D

@export var speed = 400
@export var upAction := "up"
@export var downAction := "down"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_input():
	var direction = Input.get_axis(upAction, downAction)
	velocity = Vector2(0, direction * speed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	get_input()
	move_and_slide()
