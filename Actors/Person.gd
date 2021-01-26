class_name Person
extends Actor


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var jump = Input.is_action_just_pressed("ui_up")
	var moveRightStrenght = Input.get_action_strength("ui_right") 
	var moveLeftStrenght = Input.get_action_strength("ui_left")
	
	# actor move is defined in the Actor class
	actor_move(jump, moveRightStrenght, moveLeftStrenght)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
