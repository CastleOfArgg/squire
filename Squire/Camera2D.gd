extends Camera2D

var alosolate = true
var from : Camera2D
var to : Camera2D
var time := 0.0
var total_time := 0.0
var asolate_right = true

func _ready():
	Globals.transitionCamera = self
	set_process(false)

#params : two cameras, and speed 
func start(to, from, time):
	self.time = 0.0
	self.total_time = time
	if total_time <= 0:
		finish()
		return
	
	self.to = to
	self.from = from
	self.global_transform = from.global_transform
	current = true
	set_process(true);

func _process(delta):
	if alosolate:
		if time >= total_time:
			asolate_right = false
		if time <= 0.0:
			asolate_right = true
	elif time >= total_time or time <= 0.0:
		finish()
		return
	
	if asolate_right:
		time += delta
	else:
		time -= delta
	
	self.global_transform = from.global_transform.interpolate_with(to.global_transform, time/total_time)

func finish():
	set_process(false)
	to.current = true