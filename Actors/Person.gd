class_name Person
extends Actor


# Declare member variables here. Examples:
# var a = 2
# var b = "text'

var toTheRight = [0];
var toTheLeft = [0];
var toJump = [false];
var right_index = 0
var jump_index = 0
var left_index = 0
var read = false
var hasRightMove = false
var hasLeftMove = false
var hasJumpMove = false

func initialize(right, left, jump):
	toTheRight = right
	toTheLeft = left
	toJump = jump
	if(toTheRight.size() > 0):
		hasRightMove = true
	if(toTheLeft.size() > 0):
		hasLeftMove = true
	if(toJump.size() > 0):
		hasJumpMove = true
	
# Called when the node enters the scene tree for the first time.
func _physics_process(delta): 
	var canMove = hasLeftMove || hasRightMove || hasJumpMove
	if(canMove):
		var st_jump = toJump[jump_index]
		var jump = st_jump != 'False'
		
		var st = toTheRight[right_index]
		if(st == ''):
			right_index = 0
			st = toTheRight[right_index]
		
		var st_left = toTheLeft[left_index]
		if(st_left == ''):
			left_index = 0
			st_left = toTheLeft[left_index]
		
		var moveRightStrenght = int(toTheRight[right_index])
		var moveLeftStrenght = int(toTheLeft[left_index])
		
		if(hasRightMove):
			right_index += 1 
		if(hasLeftMove):
			left_index += 1
		if(hasJumpMove):
			jump_index += 1 
		
		if(right_index >= toTheRight.size()):
			right_index = 0
			hasRightMove = false
		if(left_index >= toTheLeft.size()):
			left_index = 0
			hasLeftMove = false
		if(jump_index >= toJump.size()):
			jump_index = 0
			hasJumpMove = false
		# actor move is defined in the Actor class
		actor_move(jump, moveRightStrenght, moveLeftStrenght)

func read_moves():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
