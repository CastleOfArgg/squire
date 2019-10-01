extends Area2D

var person_class := load("res://person/person_controller.gd")

var bodies_in := []

func _on_kick_area_body_entered(body):
	bodies_in.push_back(body)
	print(body)


func _on_kick_area_body_exited(body):
	bodies_in.remove(bodies_in.find(body))


func kick():
	for body in bodies_in:
		if body.get_script() == person_class:
			body.stumble()