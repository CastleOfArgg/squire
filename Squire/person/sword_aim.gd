extends Node2D

export(int) var WIDTH := 50
export(Color) var COLOR := Color.red

export(int) var MIN_DIST := 5
export(Vector2) var STAB_SLOPE_RANGE := Vector2(0, 0.3)
export(Vector2) var SWING_SLOPE_RANGE := Vector2(0.3, 2)
export(Vector2) var SPIKE_SLOPE_RANGE := Vector2(2, INF)

var is_drawing := false
var points := PoolVector2Array()

func start(pos):
	is_drawing = true
	points.push_back(pos + self.position * 2)

func end(pos):
	is_drawing = false
	var shape = get_action_from_shape()
	points = PoolVector2Array()
	return shape

#needed to draw each frame
func _process(delta):
	update()

#add all mouse positions to pool when in use
func _input(event):
	if not is_drawing:
		return
	
	if event is InputEventMouseMotion:
		points.push_back(event.position + self.position * 2)

func _draw():
	if points.size() < 2:
		return
	
	for i in range(points.size()-2):
		draw_line(points[i], points[i+1], COLOR, WIDTH)

func get_action_from_shape():
	if points.size() < MIN_DIST:
		return -1
	
	var min_x := INF
	var min_y := INF
	var max_x := -INF
	var max_y := -INF
	
	for i in range(points.size()-1):
		if points[i].x > max_x:
			max_x = points[i].x
		if points[i].x < min_x:
			min_x = points[i].x
		if points[i].y > max_y:
			max_y = points[i].y
		if points[i].y < min_y:
			min_y = points[i].y
	
	var slope := abs((max_y - min_y) / (max_x - min_x + 0.0001))
	if slope > STAB_SLOPE_RANGE.x and slope < STAB_SLOPE_RANGE.y:
		return Globals.SWORD_STAB
	elif slope > SWING_SLOPE_RANGE.x and slope < SWING_SLOPE_RANGE.y:
		return Globals.SWORD_SWING
	else:
		return Globals.SWORD_SPIKE