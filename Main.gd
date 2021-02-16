extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var spawned = false
export var max_number_of_person = 20
var totalPeople = 0
var people = []
var spawned_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#readMoveFile()
	read_file()
	spawn_people(2)

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

func read_file():
	var scene = load("res://Actors/Person.tscn")
	var rand = RandomNumberGenerator.new()
	var file = File.new()
	file.open("user://player-move.csv", File.READ)
	var screen_size = get_viewport().get_visible_rect().size
	#var max_number_of_person = 20
	var n = 0
	while(!file.eof_reached() && n < max_number_of_person):
		n += 1 
		
		var content = file.get_csv_line()

		if(content.size() <= 1):
			break
		initalPos = Vector2(float(content[0]), float(content[1]))
	
		
		content = file.get_csv_line()
		toTheRight = content
		
		content = file.get_csv_line()
		toTheLeft = content

		content = file.get_csv_line()
		toJump = content
		
		var person = scene.instance()
		person.initialize(toTheRight, toTheLeft, toJump)
		rand.randomize()
		var x = rand.randf_range(0,screen_size.x)
		rand.randomize()
		var y = rand.randf_range(0,screen_size.y)
		person.position.y = initalPos.y
		person.position.x = initalPos.x
		people.push_back(person)
		#add_child(person)
	file.close()

func spawn_people(quantity):
	for n in quantity:
		if totalPeople >= max_number_of_person:
			return
		if spawned_index >= people.size():
			spawned_index = 0
		var person = people[spawned_index]
		add_child(person)
		spawned_index += 1
		totalPeople += 1
		

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


func _on_SpawnPersonTime_timeout():
	spawn_people(2)
	 # Replace with function body.
