class_name Player
extends Actor


#func _on_ready():
#	platform_detector.set_cast_to(PLATFORM_DETECT_DISTANCE)
#	no_platform_detector.set_cast_to(PLATFORM_DETECT_DISTANCE)
#	collision_shape_left.set_disabled(true)
#	collision_shape_right.set_disabled(false)

func _physics_process(delta):
	var jump = Input.is_action_just_pressed("ui_up")
	var moveRightStrenght = Input.get_action_strength("ui_right") 
	var moveLeftStrenght = Input.get_action_strength("ui_left")
	
	# actor move is defined in the Actor class
	actor_move(jump, moveRightStrenght, moveLeftStrenght)
