extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var spawned = false

# Called when the node enters the scene tree for the first time.
func _ready():
	readMoveFile()
	spawn_people()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if(!spawned):
#		spawn_people()
#		spawned = true
var toTheRight = [0];
var toTheLeft = [0];
var toJump = [false];
var right_index = 0
var jump_index = 0
var left_index = 0
var initalPos = Vector2(0.0, 0.0)

func spawn_people():
	var scene = load("res://Actors/Person.tscn")
	var rand = RandomNumberGenerator.new()
	var screen_size = get_viewport().get_visible_rect().size
	var max_number_of_person = 3

	for n in range(1):
		var person = scene.instance()
		person.initialize(toTheRight, toTheLeft, toJump)
		rand.randomize()
		var x = rand.randf_range(0,screen_size.x)
		rand.randomize()
		var y = rand.randf_range(0,screen_size.y)
		person.position.y = initalPos.y
		person.position.x = initalPos.y
		add_child(person)



func readMoveFile():
	var file = File.new()
	file.open("user://player-move.csv", File.READ)
	
	var content = file.get_csv_line()
	initalPos = Vector2(float(content[0]), float(content[1]))
	
	content = file.get_csv_line()
	toTheRight = content
	
	content = file.get_csv_line()
	toTheLeft = content

	content = file.get_csv_line()
	toJump = content
	#print(toJump)
	#print(content)
	file.close()
