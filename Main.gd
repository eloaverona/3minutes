extends Node

export var max_number_of_person = 20
var total_people = 0
var people = []
var spawned_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	read_file()
	spawn_people(2)

func read_file():
	var person_scene = load("res://Actors/Person.tscn")
	var file = File.new()
	file.open("user://player-move.csv", File.READ)
	var screen_size = get_viewport().get_visible_rect().size
	var inital_posistion = Vector2(0.0, 0.0)
	var to_the_right = [0]
	var to_the_left = [0]
	var to_jump = [false]
	var n = 0
	while ! file.eof_reached() && n < max_number_of_person:
		n += 1
		var content = file.get_csv_line()

		if content.size() <= 1:
			break
		inital_posistion = Vector2(float(content[0]), float(content[1]))

		content = file.get_csv_line()
		to_the_right = content

		content = file.get_csv_line()
		to_the_left = content

		content = file.get_csv_line()
		to_jump = content

		var person = person_scene.instance()
		person.initialize(to_the_right, to_the_left, to_jump)
		person.position.y = inital_posistion.y
		person.position.x = inital_posistion.x
		people.push_back(person)

	file.close()


func spawn_people(quantity):
	for n in quantity:
		if total_people >= max_number_of_person:
			return
		if spawned_index >= people.size():
			spawned_index = 0
		var person = people[spawned_index]
		add_child(person)
		spawned_index += 1
		total_people += 1

func _on_SpawnPersonTime_timeout():
	spawn_people(2)
