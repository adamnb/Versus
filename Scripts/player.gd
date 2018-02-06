extends KinematicBody2D

var spt  # Child sprite object

# Control
export var enabled     = true
export var control_m   = 0 # control method
var ctpf               = ["kb_", "gp_", "gp2_"] # list of prefixes for control methods

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

# Status
# -> HEALTH
export var immune     = false
var imm_dur           = 0
export() var health   = 100
export var max_health = 100

export var dead 	  = false 

export var printG     = false

export var def_spt    = preload("res://Textures/Players/Soldier88.tex")

func _ready():
	set_fixed_process(true)
	set_process_input(true)
	
	spt = get_node("Sprite") # Obtain child sprite object
	spt.def_spt = def_spt
	
	# Connect collision children
	get_node("Grounder").connect("body_enter", self, "_on_Area2D_body_enter")
	get_node("Grounder").connect("body_exit", self, "_on_Area2D_body_exit")
	
	get_node("HeadCollider").connect("body_enter", self, "_on_Head_body_enter")
	get_node("HeadCollider").connect("body_exit", self, "_on_Head_body_exit")
	
	# Initialize Player
	health = max_health
	
	
func _input (event):
	if (event.is_action_pressed("kb_aux0")): # Extra button for debugging
		#set_rot(get_rot()+PI/4)
		hurt(20, direction, 1)
		#print (get_pos())
		
var firstFr = true
func _fixed_process(dT):
	
	var x = get_pos().x
	var y = get_pos().y
	
	if enabled:
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
	
		speed = direction * def_spd #* dT # Final movement value
	
		#GRAVITATIONAL KINEMATICS
		if (!grounded):
			y_vel += gravity #* dTdf
			
	if health <= 0:
		print ("[PLAYER] ", get_name(), " is fuckin' dead holy shit")
		get_parent().respawn(self)
		queue_free()
		
	if immune:
		imm_dur -= dT
	
	move_and_slide(Vector2(speed, y_vel)) # The normal move() function would create too much friction


# PAIN AND SUFFERING
func hurt(damage, dir, punch):
	move (Vector2(dir * punch, 0)) # Knockback
	
	#spt = get_child(0) # I don't trust get_child() for this task, but find_node() seems to not work at all in this function

	spt.blink(0.1) # Flash
	
	health -= damage

func immunize (duration):
	immune = true
	imm_dur = duration
	
	
# Colliders & Triggers
func _on_Area2D_body_enter (body):
	if body != self:
		y_vel = 0
		grounded = true

func _on_Area2D_body_exit (body):
	grounded = false

func _on_Head_body_enter (body):

	if body != self: # Added to prevent intercollision
		print ("[PLAYER] ", get_name(), " is colliding with a foreign object, ", body.get_name())
		y_vel = 0	
		
	
func _on_Head_body_exit (body):
	print ("[PLAYER] ", get_name(), "'s head is no longer making contact with ", body.get_name())
	
