extends KinematicBody2D

var windowSize = Vector2(ProjectSettings.get("display/window/width"), ProjectSettings.get("display/window/height"))

onready var spt       = get_node("sprite")   # Child sprite object
onready var container = get_node("ElementContainer")

# Control
export var enabled     = true
export var control_m   = 0 # control method
var ctpf               = ["kb_", "gp_", "gp2_"] # list of prefixes for control methods

# Kinematics
var motion             = Vector2(0, 0)
# -> HORIZONTAL
var direction          = 0 # Directional coefficient
export var def_spd     = 1 # The default horizontal speed
var speed              = 0

# -> JUMPING
export var gravity     = 0.1 # The acceleration per frame
export var jumpVel     = 2.0 # Instantaneous velocity at jump
var y_vel              = 0   # Current target vertical motion
var grounded           = false

# Status
# -> HEALTH
export var ppos       = 0
export var immune     = false
var imm_dur           = 0
export var health     = 100
export var max_health = 100

export var dead       = false 

export var def_spt    = preload("res://Textures/Players/Soldier1212.png")

func _ready():
	set_physics_process(true)
	set_process_input(true)

	spt.def_spt = def_spt

	# Connect collision children
	$Grounder.connect("body_entered", self, "_on_Area2D_body_enter")
	$Grounder.connect("body_exited", self, "_on_Area2D_body_exit")

	# Initialize Player
	health = max_health


func _input (event):
	if (event.is_action_pressed("kb_aux0")): # Extra button for debugging
		hurt(20, direction, 1)

var fframe = true
func _physics_process(dT):
	var scale_dir = 0
	
	var x = position.x
	var y = position.y

	if fframe:
		print ("[PLAYER] ", get_name(), " is player ", ppos)
		
		var plr_indr
		
		if ppos == 1:
			plr_indr = load("res://Prefab_Scenes/Text_Resources/P1_inicator.tscn").instance()
		if ppos == 2:
			plr_indr = load("res://Prefab_Scenes/Text_Resources/P2_inicator.tscn").instance()
		
		add_child(plr_indr)
		plr_indr.position = Vector2(0, -12)
		 
		fframe = false
		
	if y - 5 > windowSize.y:
		hurt(health, 0, 0) # Kill player
		
	motion.y += gravity
	
	if enabled:

		#HORIZONTAL KINEMATICS
		if (Input.is_action_pressed(str(ctpf[control_m]) + "left")):
			direction = -1 
			container.scale = Vector2(-1, 1) 
			spt.flip_h = true

		elif (Input.is_action_pressed(str(ctpf[control_m]) + "right")):
			direction = 1
			container.scale = Vector2(1, 1)
			spt.flip_h = false

		else: 
			direction = 0

		if (Input.is_action_pressed(str(ctpf[control_m]) + "jump")):
			if grounded:
				motion.y = -jumpVel

		motion.x = direction * def_spd #* dT # Final movement value

		#GRAVITATIONAL KINEMATICS
#		if (!grounded):
#			motion.y += gravity #* dTdf
#			print ("[PLAYER] Not grounded. The grounder is at ", $Grounder.position)


	if health <= 0:
		print ("[PLAYER] ", get_name(), " is fuckin' dead holy shit")
		get_parent().respawn(self)
		queue_free()


	if immune:
		imm_dur -= dT

	motion = move_and_slide(motion) # The normal move() function would create too much friction

# PAIN AND SUFFERING
func hurt(damage, dir, punch):
	print ("[PLAYER] ", name, " took ", damage, " damage")
	move_and_collide (Vector2(dir * punch, 0)) # Knockback

	#spt = get_child(0) # I don't trust get_child() for this task, but find_node() seems to not work at all in this function

	spt.blink(0.1) # Flash

	health -= damage


func immunize (duration):
	immune = true
	imm_dur = duration


# Colliders & Triggers
func _on_Area2D_body_enter (body):
	if body != self:
		#y_vel = 0
		grounded = true
		print ("[PLAYER] ", get_name(), " is colliding with ", body.get_name())


func _on_Area2D_body_exit (body):
	grounded = false