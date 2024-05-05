extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const COYOTEE_TIME = 0.1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jumping = false
var dodging = false
var air_time = 0

@onready var animated_sprite = $AnimatedSprite2D
@onready var player = $"."

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		air_time = 0
		jumping = false

	# Handle jump.
	if 	Input.is_action_just_pressed("jump") and not jumping and air_time <= COYOTEE_TIME:
		velocity.y = JUMP_VELOCITY
		jumping = true

	#  <   |   >
	# -1   0   1
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		
	# Play animations
	if is_on_floor():
		if dodging and not animated_sprite.is_playing() or jumping:
			dodging = false
			player.collision_layer = 2
		
		if not dodging:
			if direction == 0:
				animated_sprite.play("idle")
			else:
				if Input.is_action_just_pressed("dodge"):
					animated_sprite.play("roll")
					dodging = true
				elif not animated_sprite.is_playing():
					animated_sprite.play("run")
		else:
			player.collision_layer = 1
	else:
		player.collision_layer = 2
		animated_sprite.play("jump")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	air_time += delta
