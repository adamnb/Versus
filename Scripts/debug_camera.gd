extends Camera2D

export var max_speed = 2
export var acc       = 0.2

var xspeed = 0
var yspeed = 0

var hor_ax  = 0 # Directional coefficient for horizontal axis
var vert_ax = 0 # Directional coefficient for vertical axis

var ox
var oy

func _ready():
	set_process(true)
	set_process_input(true)
	
	ox = get_pos().x
	oy = get_pos().y
	
func _process(dT):
	
	var x = get_pos().x
	var y = get_pos().y
	
	if (Input.is_action_pressed("db_cam_left")):
		hor_ax = -1
		xspeed += acc
	elif (Input.is_action_pressed("db_cam_right")):
		hor_ax = 1
		xspeed += acc
	else:
		hor_ax = 0
		xspeed = 0
		
	if (Input.is_action_pressed("db_cam_up")):
		vert_ax = -1
		yspeed += acc
	elif (Input.is_action_pressed("db_cam_down")):
		vert_ax = 1
		yspeed += acc
	else:
		vert_ax = 0
		yspeed = 0
	
	clamp(xspeed, 0, max_speed)
	clamp(yspeed, 0, max_speed)
	set_pos(Vector2(x + xspeed * hor_ax, y + yspeed * vert_ax))
	
func _input(e):
	if (e.is_action_pressed("db_cam_toggle")):
		if (is_current()):
			clear_current()
		else:
			make_current()
	
	if (e.is_action_pressed("db_cam_center")):
		set_pos(Vector2(ox, oy))
