extends KinematicBody2D

#Globals
export var MIN_NOTICE_DISTANCE := 400.0


#onready vars
onready var sword = $body/arm_r/sword
onready var anim = $AnimationTree
onready var aim = $aimmer

#vars
export var player_controlled := false
export var armour_set := false

#movement vars
export(Vector2) var DEFAULT_GRAVITY := Vector2(0, 9.8)
var gravity := DEFAULT_GRAVITY
var velocity := Vector2(0, 98)
export(Vector2) var max_velocity_x := Vector2(2000, 2000)
export(Vector2) var max_velocity_y := Vector2(2000, 2000)
export(Vector2) var velocity_increase_x := Vector2(100, 100)
export(Vector2) var velocity_increase_y := Vector2(100, 100)
export(float) var velocity_decay := 0.9
var moving_left := false
var moving_right := false
var dead := false

#weapons consts
const weapon_leg := 0
const weapon_sword := 1

#attack vars
var primary := weapon_sword
var secondary := weapon_leg
var attack_start := Vector2()
var attack_end := Vector2()
var attack := 0
var enemy

#body parts
export(Array, NodePath) var body_parts_paths := []
var body_parts := []

# Called when the node enters the scene tree for the first time.
func _ready():
	if player_controlled:
		Globals.player = self
	else:
		enemy = Globals.player
		
	if armour_set:
		$body/Area2D/MCBODY.visible = false
		$body/Area2D/MINIONBODY.visible = true
		$body/arm_l/MCARM2.visible = false
		$body/arm_l/MINIONARM2.visible = true
		$body/arm_r/MCARM.visible = false
		$body/arm_r/MINIONARM.visible = true
		$body/head/MCHEAD.visible = false
		$body/head/MINIONHEAD.visible = true
		$body/leg_l/MCLEG.visible = false
		$body/leg_l/MINIONLEG.visible = true
		$body/leg_r/MCLEG.visible = false
		$body/leg_r/MINIONLEG.visible = true
	else:
		$body/Area2D/MCBODY.visible = true
		$body/Area2D/MINIONBODY.visible = false
		$body/arm_l/MCARM2.visible = true
		$body/arm_l/MINIONARM2.visible = false
		$body/arm_r/MCARM.visible = true
		$body/arm_r/MINIONARM.visible = false
		$body/head/MCHEAD.visible = true
		$body/head/MINIONHEAD.visible = false
		$body/leg_l/MCLEG.visible = true
		$body/leg_l/MINIONLEG.visible = false
		$body/leg_r/MCLEG.visible = true
		$body/leg_r/MINIONLEG.visible = false
	
	for part in body_parts_paths:
		body_parts.append(get_node(part))
	
	anim.set_max_velocity(Vector2(max_velocity_x.x, max_velocity_y.x))

	if primary == weapon_sword:
		sword.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ai()
	#decay velocity
	if (moving_left and moving_right) or (velocity.x < -0.1 and not moving_left) or (velocity.x > 0.1 and not moving_right):
		velocity.x *= velocity_decay
	if moving_left and velocity.x > -max_velocity_x.x:
		velocity.x += -velocity_increase_x.y
	elif moving_right and velocity.x < max_velocity_x.y:
		velocity.x += velocity_increase_x.x
	#move
	velocity = move_and_slide(velocity + gravity)
	anim.set_speed(velocity)

#what should this person do
func ai():
	if player_controlled or dead:
		return
	
	ai_weak()

func stumble():
	anim.stumble()

func hit(part):
	if body_parts.find(part) != -1:
		return
	part.hit(attack)

#input for player only
func _input(event):
	if not player_controlled:
		return

	#x axis movement
	if event.is_action_pressed("move_left"):
		moving_left = true
	elif event.is_action_pressed("move_right"):
		moving_right = true
	elif event.is_action_released("move_left"):
		moving_left = false
	elif event.is_action_released("move_right"):
		moving_right = false
	#attacks
	elif event.is_action_pressed("attack"):
		attack_start = event.position
		if primary == weapon_sword:
			aim.start(attack_start)
	elif event.is_action_released("attack"):
		attack_end = event.position
		if primary == weapon_sword:
			attack = aim.end(attack_end)
			anim.sword_attack(attack)

	elif event.is_action_pressed("second_attack"):
		attack_start = event.position
		if secondary == weapon_leg: #kick
			return
	elif event.is_action_released("second_attack"):
		attack_end = event.position
		if secondary == weapon_leg: #kick
			anim.kick_attack()

func take_damage(attack):
	anim.die()
	dead = true
	moving_left = false
	moving_right = false
	self.collision_layer = 2
	self.collision_mask  = 2


func ai_weak():
	moving_left = false
	moving_right = false
	var dist = global_position.x - enemy.global_position.x
	if dist > 0 and abs(dist) < MIN_NOTICE_DISTANCE:
		moving_left = true
	elif dist > 0 and abs(dist) < MIN_NOTICE_DISTANCE:
		moving_right = true