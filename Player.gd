extends KinematicBody2D


export var SPEED = Vector2(150.0, 350.0)
onready var GRAVITY = ProjectSettings.get("physics/2d/default_gravity")
onready var platform_detector = $PlatformDetector
onready var animation_player = $AnimationPlayer
onready var shoot_timer = $ShootAnimation
onready var sprite = $AnimatedSprite

const FLOOR_NORMAL = Vector2.UP
const FLOOR_DETECT_DISTANCE = 20.0

var velocity = Vector2.ZERO


func _physics_process(delta):
	velocity.y += delta * GRAVITY
	$AnimatedSprite.play()
#
#	if Input.is_action_pressed("ui_left"):
#		velocity.x = -WALK_SPEED
#	elif Input.is_action_pressed("ui_right"):
#		velocity.x =  WALK_SPEED
#	else:
#		velocity.x = 0
#
#	# We don't need to multiply velocity by delta because "move_and_slide" already takes delta time into account.
#
#	# The second parameter of "move_and_slide" is the normal pointing up.
#	# In the case of a 2D platformer, in Godot, upward is negative y, which translates to -1 as a normal.
#	move_and_slide(velocity, Vector2(0, -1))
	var direction = get_direction()

	var is_jump_interrupted = Input.is_action_just_released("ui_up") and velocity.y < 0.0


	velocity = calculate_move_velocity(velocity, direction, SPEED, is_jump_interrupted)

	var snap_vector = Vector2.DOWN * FLOOR_DETECT_DISTANCE if direction.y == 0.0 else Vector2.ZERO
	var is_on_platform = platform_detector.is_colliding()
	velocity = move_and_slide_with_snap(
		velocity, snap_vector, FLOOR_NORMAL, not is_on_platform, 4, 0.9, false
	)

	# When the character’s direction changes, we want to to scale the Sprite accordingly to flip it.
	# This will make Robi face left or right depending on the direction you move.



	if direction.x != 0:
		$AnimatedSprite.flip_v = false
		# See the note below about boolean assignment
		$AnimatedSprite.flip_h = velocity.x < 0
		#sprite.flip_v = false if direction.x > 0 else -1
		
	var animation = get_new_animation(false)
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
	velocity.x = speed.x * direction.x
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		# Decrease the Y velocity by multiplying it, but don't set it to 0
		# as to not be too abrupt.
		velocity.y *= 0.6
	return velocity


func get_new_animation(is_shooting = false):
	var animation_new = ""
	if is_on_floor():
		animation_new = "run" if abs(velocity.x) > 0.1 else "idle"
	else:
		animation_new = "jump"
	
	return animation_new
