extends KinematicBody2D


export var SPEED = Vector2(80.0, 200.0)
export var ACCELERATION = Vector2(10.0, 0)
export var FRICTION = Vector2(0.75, 0)
onready var GRAVITY = ProjectSettings.get("physics/2d/default_gravity")
onready var platform_detector = $PlatformDetector
onready var animation_player = $AnimationPlayer
onready var sprite = $AnimatedSprite

const FLOOR_NORMAL = Vector2.UP
const FLOOR_DETECT_DISTANCE = 20.0

var velocity = Vector2.ZERO


func _physics_process(delta):
	velocity.y += delta * GRAVITY  ## player is affected by gravity
	
	$AnimatedSprite.play()
	
	var direction = get_direction()

	var is_jump_interrupted = Input.is_action_just_released("ui_up") and velocity.y < 0.0


	velocity = calculate_move_velocity(velocity, direction, SPEED, is_jump_interrupted)

	var snap_vector = Vector2.DOWN * FLOOR_DETECT_DISTANCE if direction.y == 0.0 else Vector2.ZERO

	velocity = move_and_slide_with_snap(
		velocity, snap_vector, FLOOR_NORMAL, false, 4, 0.9, false
	)

	# When the character’s direction changes, we want to to scale the Sprite accordingly to flip it.
	# This will make the character face left or right depending on the direction you move.

	if direction.x != 0:
		$AnimatedSprite.flip_v = false
		# See the note below about boolean assignment
		$AnimatedSprite.flip_h = velocity.x < 0

		
	var animation = get_new_animation()
	$AnimatedSprite.animation = animation



func get_direction():
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		-1 if is_on_floor() and Input.is_action_just_pressed("ui_up") else 0
	)


# This function calculates a new velocity whenever you need it.
# It allows you to interrupt jumps.
func calculate_move_velocity(
		linear_velocity,
		direction,
		speed,
		is_jump_interrupted
	):
	var velocity = linear_velocity
	velocity.x = velocity.x  + (direction.x * ACCELERATION.x)
	#print(direction.x * ACCELERATION.x)
	if(velocity.x > SPEED.x):
		velocity.x = SPEED.x
	elif(velocity.x < -SPEED.x):
		velocity.x = -SPEED.x
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	if direction.x == 0:
		velocity.x *= FRICTION.x
		
	#print(velocity)
#	if is_jump_interrupted:
#		# Decrease the Y velocity by multiplying it, but don't set it to 0
#		# as to not be too abrupt.
#		velocity.y *= 0.9
	
	return velocity


func get_new_animation():
	var animation_new = ""
	if is_on_floor():
		animation_new = "run" if abs(velocity.x) > 0.1 else "idle"
	else:
		animation_new = "fall" if velocity.y > 0 else "jump"
	return animation_new
