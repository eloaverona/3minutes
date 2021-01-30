class_name Person
extends Actor


# Declare member variables here. Examples:
# var a = 2
# var b = "text'

var toTheRight = [0];
var toTheLeft;
var jump;
var index = 0
var read = false

# Called when the node enters the scene tree for the first time.
func _physics_process(delta): 
	if(!read):
		var file = File.new()
		file.open("user://player-move.csv", File.READ)
		var content = file.get_csv_line()
		toTheRight = content
		#print(content)
		read = true
	var jump = Input.is_action_just_pressed("ui_up")
	var st = toTheRight[index]
	if(st == ''):
		index = 0
		st = toTheRight[index]
	var moveRightStrenght = int(toTheRight[index])
	var moveLeftStrenght = Input.get_action_strength("ui_left")
	index += 1 
	if(index >= toTheRight.size()):
		index = 0
	# actor move is defined in the Actor class
	actor_move(false, moveRightStrenght, moveLeftStrenght)

func read_moves():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
