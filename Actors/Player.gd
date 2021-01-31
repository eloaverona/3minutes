class_name Player
extends Actor

export var record = false
var moveRightRecord = []
var moveLeftRecord = []
var jumpRecord = []

func _physics_process(delta):

	var jump = Input.is_action_just_pressed("ui_up")
	var moveRightStrenght = Input.get_action_strength("ui_right") 
	var moveLeftStrenght = Input.get_action_strength("ui_left")
	if(record):
		record_moves(moveRightStrenght, moveLeftStrenght, jump)

	# actor move is defined in the Actor class
	actor_move(jump, moveRightStrenght, moveLeftStrenght)

func record_moves(right, left, jump):
	var moveRight = "%d" % right
	var moveLeft = "%d" % left
	var moveJump = "%s" % jump
	moveRightRecord.push_back(moveRight)
	moveLeftRecord.push_back(moveLeft)
	jumpRecord.push_back(moveJump)
	
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST && record:
		var file = File.new()
		# data is saved at ~/.local/share/godot/app_userdata/3minutes/
		file.open("user://player-move.csv", File.READ_WRITE)
		file.seek_end()
		#file.store_string('\n')
		file.store_csv_line(PoolStringArray(moveRightRecord))
		file.store_csv_line(PoolStringArray(moveLeftRecord))
		file.store_csv_line(PoolStringArray(jumpRecord))
		file.close()

