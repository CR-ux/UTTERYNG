class_name Aria
extends CharacterBody2D

@export var speed = 300
@export var gravity := 1200.0


func _physics_process(delta):
	velocity.y += gravity * delta
	get_input()

	if velocity != Vector2.ZERO:
		move_and_collide(velocity * delta)


func play_animation(dir: String):
	match dir:
		"right":
			$AriaSprite.animation = "walk"
			$AriaSprite.flip_h = false
			$AriaSprite.flip_v = false
		"left":
			$AriaSprite.animation = "walk"
			$AriaSprite.flip_h = true
			$AriaSprite.flip_v = false
		"down":
			$AriaSprite.animation = "down"
			$AriaSprite.flip_v = false
			$AriaSprite.flip_h = false
		"up":
			$AriaSprite.animation = "down"
			$AriaSprite.flip_v = true
			$AriaSprite.flip_h = false
		"idle":
			$AriaSprite.animation = "stand"
			$AriaSprite.flip_v = false
		"sit":
			$AriaSprite.animation = "sit"
			$AriaSprite.flip_v = false
	$AriaSprite.play()


func get_input():
	var input_vector = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		input_vector.x += 1
	elif Input.is_action_pressed("move_left"):
		input_vector.x -= 1
	elif Input.is_action_pressed("move_down"):
		input_vector.y += 1
	elif Input.is_action_pressed("move_up"):
		input_vector.y -= 1
	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()
		velocity = input_vector * speed
		$SitTimer.stop()
		if abs(input_vector.x) > abs(input_vector.y):
			play_animation("right" if input_vector.x > 0 else "left")
		else:
			play_animation("down" if input_vector.y > 0 else "up")
	else:
		if velocity != Vector2.ZERO:
			velocity = Vector2.ZERO
			play_animation("idle")
			$SitTimer.start()

		

func start():
	show()
	$AriaCollider.disabled = false


func _on_sit_timer_timeout() -> void:
	if velocity == Vector2.ZERO:
		play_animation("sit")
