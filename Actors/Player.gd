class_name Player
extends Actor

export var record = true
var move_right_record = []
var move_left_record = []
var jump_record = []
var initial_position = Vector2(0.0, 0.0)


func _ready():
	initial_position = global_position


func _physics_process(_delta):
	var jump = Input.is_action_just_pressed("ui_up")
	var move_right_strenght = Input.get_action_strength("ui_right")
	var move_left_strenght = Input.get_action_strength("ui_left")
	if record:
		record_moves(move_right_strenght, move_left_strenght, jump)

	# actor move is defined in the Actor class
	actor_move(jump, move_right_strenght, move_left_strenght)


func record_moves(right, left, jump):
	var move_right = "%d" % right
	var move_left = "%d" % left
	var move_jump = "%s" % jump
	move_right_record.push_back(move_right)
	move_left_record.push_back(move_left)
	jump_record.push_back(move_jump)


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST && record:
		var file = File.new()
		# data is saved at ~/.local/share/godot/app_userdata/3minutes/
		file.open("user://player-move.csv", File.READ_WRITE)
		file.seek_end()
		#file.store_string('\n')
		var x_position = '%f' % initial_position.x
		var y_position = '%f' % initial_position.y
		var pos = [x_position, y_position]
		file.store_csv_line(PoolStringArray(pos))
		file.store_csv_line(PoolStringArray(move_right_record))
		file.store_csv_line(PoolStringArray(move_left_record))
		file.store_csv_line(PoolStringArray(jump_record))
		file.close()
