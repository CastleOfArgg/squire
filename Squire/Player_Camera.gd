extends Camera2D

#zoom vars
var is_zooming := false
var zoom_to_size := Vector2(1,1)
var zoom_to_time := 0

#transform vars
var is_transforming := false
var transform_to_pos := Vector2(1,1)
var transform_to_time := 0


#transform to pos over given time
func transform_to(pos, time=0):
	if time == 0:
		transform.origin = pos
		is_transforming = false
		return
	is_transforming = true

#zoom to size over given time
func zoom_to(size, time=0):
	if time == 0:
		zoom = size
		is_zooming = false
		return
	is_zooming = true

#process
func _process(delta):
	if is_zooming:
		zoom_to_time =- delta
		if zoom_to_time <= 0:
			zoom_to(zoom_to_size)
		else:
			zoom = (zoom_to_size - zoom) * (1 - zoom_to_time)
	
	if is_transforming:
		transform_to_time =- delta
		if transform_to_time <= 0:
			zoom_to(transform_to_pos)
		else:
			transform.origin = (transform_to_pos - transform.origin) * (1 - transform_to_time)