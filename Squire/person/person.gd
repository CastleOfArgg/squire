extends Node2D

#vars
export(bool) var player_controlled := false
onready var body := $kinematic_body
export(Vector2) var STUMBLE_DISTANCE := Vector2(500, 0)
var stumble_velocity := Vector2()
var stumble_time := 0
var is_stumbling := false

func _ready():
	body.player_controlled = player_controlled

func stumble(time=3):
	is_stumbling = true
	stumble_time = time
	stumble_velocity = STUMBLE_DISTANCE

func _process(delta):
	if is_stumbling:
		stumble_time -= delta
		if(stumble_time <= 0):
			is_stumbling = false
			print("A")
		print(stumble_velocity)
		stumble_velocity = body.move_and_slide(stumble_velocity)