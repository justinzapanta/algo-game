extends CharacterBody2D


const SPEED = 300.0

#doon sa number parameter lagay lang negative number(-100) if left or back
#then positive number(100) if riight or forward

#doon sa axis parameter lagay mo 'x' if left or right mag wwalk then y if forward or backward

func walk(number, axis):
	if axis == 'x':
		velocity.x = number
		if number < 0:
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("walk")
		else:
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("walk")
	else:
		velocity.y = number	
		if number < 0:
			$AnimatedSprite2D.play("back")
		else:
			$AnimatedSprite2D.play("forward")


func _physics_process(delta):
	var walk_x = Input.get_axis("left", "right")
	var walk_y = Input.get_axis("back", "down")
	if walk_x or walk_y:
		walk((SPEED * walk_x), 'x')
		walk((SPEED * walk_y), 'y')
	else:
		velocity.x = 0
		velocity.y = 0
		$AnimatedSprite2D.play("idle")
	
	move_and_slide()
