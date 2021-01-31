extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var spawned = false

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_people()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	if(!spawned):
#		spawn_people()
#		spawned = true

func spawn_people():
	var scene = load("res://Actors/Person.tscn")
	var rand = RandomNumberGenerator.new()
	var screen_size = get_viewport().get_visible_rect().size
	for n in range(1):
		var person = scene.instance()
		rand.randomize()
		var x = rand.randf_range(0,screen_size.x)
		rand.randomize()
		var y = rand.randf_range(0,screen_size.y)
		person.position.y = 10
		person.position.x = 50 + (n*10)
		add_child(person)
