extends AnimationTree

var playback : AnimationNodeStateMachinePlayback
var max_velocity := Vector2()

func _ready():
	playback = get("parameters/playback")
	active = true

func set_max_velocity(velocity):
	max_velocity = velocity

func set_speed(velocity):
	set("parameters/Motion/Motion/blend_position", velocity / max_velocity)

func kick_attack():
	set("parameters/Motion/Kick/active", true)

func stumble():
	playback.travel("Stumble")

func stumble_end():
	playback.travel("Motion")

func die():
	playback.travel("sword_death_stab")

func sword_attack(attack_num):
	if attack_num == -1:
		return
	elif attack_num == Globals.SWORD_STAB:
		set("parameters/Motion/Stab/active", true)
	elif attack_num == Globals.SWORD_SWING:
		set("parameters/Motion/Swing_Up/active", true)
	else:
		set("parameters/Motion/Spike/active", true)