extends Area2D

export var speed := 100.0
export var to : NodePath
export var from : NodePath
var to_camera : Camera2D
var from_camera : Camera2D
var on := true

func _ready():
	to_camera = get_node(to)
	from_camera = get_node(from)

func _on_cameraTrigger_body_entered(body):
	if on and body.player_controlled:
		on = false
