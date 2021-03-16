class_name Person
extends Actor

var to_the_right = [0]
var to_the_left = [0]
var to_jump = [false]
var right_index = 0
var jump_index = 0
var left_index = 0
var read = false
var has_right_move = false
var has_left_move = false
var has_jump_move = false


func initialize(right, left, jump):
	to_the_right = right
	to_the_left = left
	to_jump = jump
	if to_the_right.size() > 0:
		has_right_move = true
	if to_the_left.size() > 0:
		has_left_move = true
	if to_jump.size() > 0:
		has_jump_move = true


# Called when the node enters the scene tree for the first time.
func _physics_process(_delta):
	var can_move = has_left_move || has_right_move || has_jump_move
	if can_move:
		var st_jump = to_jump[jump_index]
		var jump = st_jump != 'False'

		var st = to_the_right[right_index]
		if st == '':
			right_index = 0
			st = to_the_right[right_index]

		var st_left = to_the_left[left_index]
		if st_left == '':
			left_index = 0
			st_left = to_the_left[left_index]

		var move_right_strenght = int(to_the_right[right_index])
		var move_left_strenght = int(to_the_left[left_index])

		if has_right_move:
			right_index += 1
		if has_left_move:
			left_index += 1
		if has_jump_move:
			jump_index += 1

		if right_index >= to_the_right.size():
			right_index = 0
			has_right_move = false
		if left_index >= to_the_left.size():
			left_index = 0
			has_left_move = false
		if jump_index >= to_jump.size():
			jump_index = 0
			has_jump_move = false
		# actor move is defined in the Actor class
		actor_move(jump, move_right_strenght, move_left_strenght)

