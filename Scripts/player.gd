	extends KinematicBody2D

var spt # Child sprite object

# Control
export var control_m = 0 # control method
var ctpf             = ["kb_", "gp_"] # list of prefixes for control methods

# Kinematics
# -> HORIZONTAL
var direction          = 0 # Directional coefficient
export var def_spd     = 1 # The default horizontal speed
var speed              = 0

# -> JUMPING
export var gravity     = 0.1 #The acceleration per frame
export var jumpVel     = 2.0
var y_vel              = 0
var grounded           = false

# ->-> MULTI-JUMPING
export var ex_jumps    = 1 # Amount of other mid-air jumps possible
var cur_ex_jumps       = 0 # Current amount of left over jumps
export var ex_jump_vel = 1.0

#Sprite

func _ready():
	set_fixed_process(true)
	set_process_input(true)
	
	spt = find_node("Sprite") # Obtain child sprite object
	
	get_node("Grounder").connect("body_enter",self,"_on_Area2D_body_enter")
	get_node("Grounder").connect("body_exit",self,"_on_Area2D_body_exit")
	
	get_node("HeadCollider").connect("body_enter", self, "_on_Head_body_enter")
	
	
func _input (event):
	if !grounded:
		if (event.is_action_pressed(str(ctpf[control_m]) + "jump")):
			print ("DOUBLE JUMP ATTEMPTED")
			if cur_ex_jumps > 0:
				print ("DOUBLE JUMP AVAILABLE", str(cur_ex_jumps))
				cur_ex_jumps -= 1
				print (cur_ex_jumps)
				
				y_vel = -(ex_jump_vel*2)
		
func _fixed_process(dT):
	var x = get_pos().x
	var y = get_pos().y
	
	#HORIZONTAL KINEMATICS
	if (Input.is_action_pressed(str(ctpf[control_m]) + "left")):
		#spt.set_flip_h(true)
		set_scale(Vector2(-1, 1))
		direction = -1

	elif (Input.is_action_pressed(str(ctpf[control_m]) + "right")):
		#spt.set_flip_h(false)
		set_scale(Vector2(1, 1))
		direction = 1
		
	else: 
		direction = 0
		
	if (Input.is_action_pressed("kb_aux0")): # Pointless debug spin DELET THIS
		set_rot(get_rot()+PI/4)
	
	if (Input.is_action_pressed(str(ctpf[control_m]) + "jump")):
		if grounded:
			y_vel = -jumpVel
			cur_ex_jumps = ex_jumps
		
		

	speed = direction * def_spd #* dT

	#GRAVITATIONAL KINEMATICS
	if (!grounded):
		y_vel += gravity #* dT

	move_and_slide(Vector2(speed, y_vel))

func _on_Area2D_body_enter (body):
	if body != self:
		grounded = true

func _on_Area2D_body_exit (body):
	grounded = false
	
func _on_Head_body_enter (body):
	y_vel = 0
	