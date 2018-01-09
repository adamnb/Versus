extends KinematicBody2D

var spt # Child sprite object

# Control
export var enabled   = true
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

# Status
# -> HEALTH
export() var health
export var max_health = 100 


func _ready():
	set_fixed_process(true)
	set_process_input(true)
	
	spt = find_node("Sprite") # Obtain child sprite object
	
	# Connect collision children
	get_node("Grounder").connect("body_enter", self, "_on_Area2D_body_enter")
	get_node("Grounder").connect("body_exit", self, "_on_Area2D_body_exit")
	
	get_node("HeadCollider").connect("body_enter", self, "_on_Head_body_enter")
	
	# Initialize Player
	health = max_health
	
	
func _input (event):
	if (event.is_action_pressed("kb_aux0")): # Extra button for debugging
		#set_rot(get_rot()+PI/4)
		hurt(10, 1, 10)
		
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
	
	if (Input.is_action_pressed(str(ctpf[control_m]) + "jump")):
		if grounded:
			y_vel = -jumpVel
			cur_ex_jumps = ex_jumps
		
	speed = direction * def_spd #* dT # Final movement value

	#GRAVITATIONAL KINEMATICS
	if (!grounded):
		y_vel += gravity #* dT

	move_and_slide(Vector2(speed, y_vel)) # The normal move() function would create too much friction
	
	if health <= 0:
		queue_free()
	
	
# PAIN AND SUFFERING
func hurt(damage, dir, punch):
	health -= damage
	#move (Vector2(dir * punch, 0))
	
	print (get_name(), " Took ", damage, " damage and now has ", health, " health.")


# Colliders & Triggers
func _on_Area2D_body_enter (body):
	if body != self:
		grounded = true

func _on_Area2D_body_exit (body):
	grounded = false
	
func _on_Head_body_enter (body):
	y_vel = 0
	