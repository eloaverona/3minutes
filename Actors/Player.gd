class_name Player
extends Actor


var t = []
func _physics_process(delta):

	var jump = Input.is_action_just_pressed("ui_up")
	var moveRightStrenght = Input.get_action_strength("ui_right") 
	var moveLeftStrenght = Input.get_action_strength("ui_left")
	var r = "%d" % moveRightStrenght
	t.push_back(r)

	# actor move is defined in the Actor class
	actor_move(jump, moveRightStrenght, moveLeftStrenght)

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		var file = File.new()
		# data is saved at ~/.local/share/godot/app_userdata/3minutes/
		file.open("user://player-move.csv", File.READ_WRITE)
		file.seek_end()
		#file.store_string('\n')
		file.store_csv_line(PoolStringArray(t))
		file.close()
		print("got here")
