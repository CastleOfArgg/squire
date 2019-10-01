extends "weapon.gd"

var weapon_script = load("res://weapons/weapon.gd")
var body_part_script = load("res://person/body_part.gd")

export(NodePath) var parent_path 
var parent : KinematicBody2D

func _ready():
	parent = get_node(parent_path)

func _on_Area2D_area_entered(area):
	if not attacking:
		return
	
	if area.get_script() == weapon_script:
		attacking = false
	
	if area.get_script() == body_part_script:
		parent.hit(area)

func attack_start():
	attacking = true

func attacking_end():
	attacking = false