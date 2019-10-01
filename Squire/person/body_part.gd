extends Area2D

onready var blood = $CPUParticles2D
export(NodePath) var parent_path : NodePath
var parent : KinematicBody2D

func _ready():
	parent = get_node(parent_path)

func hit(attack):
	print("blood")
	blood.emitting = true
	parent.take_damage(attack)