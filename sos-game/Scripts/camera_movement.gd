extends CharacterBody2D

@export var speed = 200.0
var input : Vector2

func get_input() :
	input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	return input.normalized() #make diagonal movement same speed
	
func _process(_delta: float) :
	var playerInput = get_input()
	velocity = playerInput * speed
	move_and_slide()
