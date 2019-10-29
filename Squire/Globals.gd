extends Node

#external vars
var SWORD_STAB := 0
var SWORD_SPIKE := 1
var SWORD_SWING := 2

#global vars
var transitionCamera : Camera2D
var player : KinematicBody2D

#internal vars
var debugging := true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


#input for debugging only
func _input(event):
	if not debugging:
		return
	
	if event.is_action_pressed("debug_exit_game"):
		get_tree().quit()
	
	if event.is_action_pressed("debug_restart_level"):
		get_tree().change_scene(get_tree().get_current_scene().get_filename())