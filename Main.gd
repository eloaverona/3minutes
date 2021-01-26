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
	for n in range(9):
		var person = scene.instance()
		add_child(person)
