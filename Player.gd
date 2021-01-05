extends KinematicBody2D


export var SPEED = Vector2(80.0, 200.0)
export var ACCELERATION = Vector2(10.0, 0)
export var FRICTION = Vector2(0.75, 0)
onready var GRAVITY = ProjectSettings.get("physics/2d/default_gravity")
onready var platform_detector = $PlatformDetector
onready var no_platform_detector = $NoPlatformDetector
#onready var animation_player = $AnimationPlayer
onready var sprite = $AnimatedSprite

const FLOOR_NORMAL = Vector2.UP
const PLATFORM_DETECT_DISTANCE = Vector2(6.0, 0.0)

var velocity = Vector2.ZERO
var pressedJump = false
var isClimbing = false
onready var isOnPlatform = is_on_floor()

func _on_ready():
	platform_detector.set_cast_to(PLATFORM_DETECT_DISTANCE)
	no_platform_detector.set_cast_to(PLATFORM_DETECT_DISTANCE)

func _physics_process(delta):
	velocity.y += delta * GRAVITY  ## player is affected by gravity
	
	$AnimatedSprite.play()
	
	var player_jumped = process_jump()
	
	process_climb()
	
	var direction = get_direction(player_jumped)

	var is_jump_interrupted = Input.is_action_just_released("ui_up") and velocity.y < 0.0


	velocity = calculate_move_velocity(velocity, direction, SPEED, is_jump_interrupted)

	var snap_vector = Vector2.DOWN * PLATFORM_DETECT_DISTANCE if direction.y == 0.0 else Vector2.ZERO

	velocity = move_and_slide_with_snap(
		velocity, snap_vector, FLOOR_NORMAL, false, 4, 0.9, false
	)

	# When the character’s direction changes, we want to to scale the Sprite accordingly to flip it.
	# This will make the character face left or right depending on the direction you move.

	if direction.x != 0:
		sprite.flip_v = false
		sprite.flip_h = direction.x < 0
		platform_detector.set_cast_to(Vector2(PLATFORM_DETECT_DISTANCE.x * direction.x, PLATFORM_DETECT_DISTANCE.y))
		no_platform_detector.set_cast_to(Vector2(PLATFORM_DETECT_DISTANCE.x * direction.x, PLATFORM_DETECT_DISTANCE.y))
		
	var animation = get_new_animation()
	sprite.animation = animation

func process_climb():
	if(!isOnPlatform):
#		print("get here")
#		print(velocity)		
		if(platform_detector.is_colliding() && !no_platform_detector.is_colliding()):
			isClimbing = true
#			print("get here 2")
		else:
			isClimbing = false

func process_jump():
	var playerJumped = false;
	# if player pressed jump in the last 0.2 seconds, even if they are
	# not on the floor, they can still jump up
	if(Input.is_action_just_pressed("ui_up")):
		pressedJump = true
		$PressedJumpTimer.start()
	
	# if player left the platform in the last 0.1 seconds, even if they are
	# not on the floor, they can still jump up
	if(is_on_floor()):
		isOnPlatform = true
		$LeftPlatformTimer.start()
		
	if((isOnPlatform || isClimbing) && pressedJump):
		playerJumped = true
		if(isClimbing):
			platform_detector.set_enabled(false)
			no_platform_detector.set_enabled(false)
			yield(get_tree().create_timer(0.2), "timeout")		
			platform_detector.set_enabled(true)
			no_platform_detector.set_enabled(true)
		resetJump()
	return playerJumped

func get_direction(playerJumped):
	return Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		-1 if playerJumped else 0
	)

func resetJump():
	pressedJump = false
	$PressedJumpTimer.stop()

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
		#if(!isClimb && isOnPlatform):
		velocity.y = speed.y * direction.y
		#else: 
		#	velocity.y = 0
	if direction.x == 0:
		velocity.x *= FRICTION.x
	
	if(isClimbing):
		velocity.y = 0
		
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


func _on_PressedJumpTimer_timeout():
	resetJump()

func _on_LeftPlatformTimer_timeout():
	isOnPlatform = false
	$LeftPlatformTimer.stop()
