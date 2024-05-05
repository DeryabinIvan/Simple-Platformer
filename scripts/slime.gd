extends Node2D

const SPEED = 60

var direction = 1
var state = 0

@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == 1:
		if ray_cast_right.is_colliding():
			direction = -1
			animated_sprite.flip_h = true
			
		if ray_cast_left.is_colliding():
			direction = 1
			animated_sprite.flip_h = false

		position.x += direction * SPEED * delta
	
func _physics_process(delta):
	var distance = (global_position - %player.global_position)
	if distance.length() <= 50 and state == 0:
		state = 1
		animated_sprite.play("awakening")
		animated_sprite.play("moving")


func _on_area_2d_body_entered(body):
	state = 0
	$AnimationPlayer.play("hit")
	%GameManager.add_point()
