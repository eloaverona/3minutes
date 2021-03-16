class_name Actor
extends KinematicBody2D


const FLOOR_NORMAL = Vector2.UP
export var SPEED = Vector2(80.0, 200.0)
export var ACCELERATION = Vector2(10.0, 0)
export var FRICTION = Vector2(0.75, 0)
export var PLATFORM_DETECT_DISTANCE = Vector2(6.0, 0.0)

onready var gravity = ProjectSettings.get("physics/2d/default_gravity")
onready var platform_detector = $PlatformDetector
onready var no_platform_detector = $NoPlatformDetector
onready var is_on_platform = is_on_floor()
#onready var animation_player = $AnimationPlayer
onready var sprite = $AnimatedSprite
onready var collision_shape_right = $CollisionShape2D_right
onready var collision_shape_left = $CollisionShape2D_left
onready var velocity = Vector2.ZERO
onready var pressed_jump = false
onready var is_climbing = false



func _ready():
	platform_detector.set_cast_to(PLATFORM_DETECT_DISTANCE)
	no_platform_detector.set_cast_to(PLATFORM_DETECT_DISTANCE)
	collision_shape_left.set_disabled(true)
	collision_shape_right.set_disabled(false)
	$LeftPlatformTimer.connect("timeout", self, "_on_LeftPlatformTimer_timeout")
	$PressedJumpTimer.connect("timeout", self, "_on_PressedJumpTimer_timeout")


func _physics_process(delta):
	velocity.y += delta * gravity  ## player is affected by gravity


## Handles all logic of player moving, including direction, jumps, climbs and animation
func actor_move(jump, move_right_strenght, move_left_strenght):
	$AnimatedSprite.play()

	var player_jumped = process_jump(jump)

	process_climb()

	var direction = get_direction(player_jumped, move_right_strenght, move_left_strenght)

	velocity = calculate_move_velocity(velocity, direction, SPEED)

	var snap_vector = (
		Vector2.DOWN * PLATFORM_DETECT_DISTANCE
		if direction.y == 0.0
		else Vector2.ZERO
	)

	velocity = move_and_slide_with_snap(velocity, snap_vector, FLOOR_NORMAL, false, 4, 0.9, false)

	# When the character’s direction changes, we want to to scale the Sprite accordingly to flip it.
	# This will make the character face left or right depending on the direction you move.

	if direction.x != 0:
		var is_going_left = direction.x < 0

		sprite.flip_h = is_going_left
		collision_shape_left.set_disabled(! is_going_left)
		collision_shape_right.set_disabled(is_going_left)

		update_platform_detection_direction(direction)

	var animation = get_new_animation()
	sprite.animation = animation


# The platform_detector and the no_platform_detector are used to
# detect when the player shoud climb.
# This updates the direction of the platform_detector and the no_platform_detector
# depending on the direction the player is facing.
func update_platform_detection_direction(direction):
	var vector = Vector2(PLATFORM_DETECT_DISTANCE.x * direction.x, PLATFORM_DETECT_DISTANCE.y)
	platform_detector.set_cast_to(vector)

	vector = Vector2(PLATFORM_DETECT_DISTANCE.x * direction.x, PLATFORM_DETECT_DISTANCE.y)
	no_platform_detector.set_cast_to(vector)


func process_climb():
	if ! is_on_platform:
		if platform_detector.is_colliding() && ! no_platform_detector.is_colliding():
			is_climbing = true
		else:
			is_climbing = false


func process_jump(jump = false):
	var player_jumped = false
	# if player pressed jump in the last 0.2 seconds, even if they are
	# not on the floor, they can still jump up
	if jump:
		pressed_jump = true
		$PressedJumpTimer.start()

	# if player left the platform in the last 0.1 seconds, even if they are
	# not on the floor, they can still jump up
	if is_on_floor():
		is_on_platform = true
		$LeftPlatformTimer.start()

	if (is_on_platform || is_climbing) && pressed_jump:
		player_jumped = true
		if is_climbing:
			platform_detector.set_enabled(false)
			no_platform_detector.set_enabled(false)
			yield(get_tree().create_timer(0.2), "timeout")
			platform_detector.set_enabled(true)
			no_platform_detector.set_enabled(true)
		reset_jump()
	return player_jumped


func get_direction(player_jumped, move_right, move_left):
	return Vector2(move_right - move_left, -1 if player_jumped else 0)


func reset_jump():
	pressed_jump = false
	$PressedJumpTimer.stop()


# This function calculates a new velocity whenever you need it.
# It allows you to interrupt jumps.
func calculate_move_velocity(linear_velocity, direction, speed):
	var velocity = linear_velocity
	velocity.x = velocity.x + (direction.x * ACCELERATION.x)
	if velocity.x > SPEED.x:
		velocity.x = SPEED.x
	elif velocity.x < -SPEED.x:
		velocity.x = -SPEED.x
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	if direction.x == 0:
		velocity.x *= FRICTION.x

	if is_climbing:
		velocity.y = 0

	return velocity


func get_new_animation():
	var animation_new = ""
	if is_on_floor():
		animation_new = "run" if abs(velocity.x) > 0.1 else "idle"
	elif is_climbing:
		animation_new = "climb"
	else:
		animation_new = "fall" if velocity.y > 0 else "jump"
	return animation_new


func _on_PressedJumpTimer_timeout():
	reset_jump()


func _on_LeftPlatformTimer_timeout():
	is_on_platform = false
	$LeftPlatformTimer.stop()
