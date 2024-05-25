extends CharacterBody2D

const max_speed = 100

var input = Vector2.ZERO
var current_direction = Vector2.ZERO
var current_animation = ""

func _physics_process(delta):
	player_movement(delta)
	play_direction_animation(delta)

func get_input():
	input.x = int(Input.is_action_pressed("ui_right")) - int (Input.is_action_pressed("ui_left"))
	input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	return input.normalized()

func player_movement(delta):
	input = get_input()
	
	if input == Vector2.ZERO:
		velocity = Vector2.ZERO
	else:
		velocity = input * max_speed
	
	move_and_slide()


func play_direction_animation(delta):
	var anim = $AnimatedSprite2D
	var new_animation = ""

	if input.x != 0 or input.y != 0:
		current_direction = input

	if current_direction.x != 0 and velocity.length() > 0:
		anim.flip_h = current_direction.x < 0
		new_animation = "walk_side"
	elif current_direction.y > 0 and velocity.length() > 0:
		new_animation = "walk_down"
	elif current_direction.y < 0 and velocity.length() > 0:
		new_animation = "walk_up"
	else:
		new_animation = "idle_side"
		
		if current_animation.ends_with("_side"):
			new_animation = "idle_side"
		elif current_animation.ends_with("_down"):
			new_animation = "idle_down"
		elif current_animation.ends_with("_up"):
			new_animation = "idle_up"

	if new_animation != current_animation:
		anim.play(new_animation)
		current_animation = new_animation
