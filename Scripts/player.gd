extends KinematicBody2D

var windowSize = Vector2(ProjectSettings.get("display/window/width"), ProjectSettings.get("display/window/height"))

onready var spt       = get_node("sprite")   # Child sprite object
onready var container = get_node("ElementContainer")
onready var shooter   = container.get_node("BulletSource")
onready var rld_anim  = $ReloadRadial # Animated reload indidcator

# Control
export var enabled      = true # Does the player have control?
export var control_m    = 0 # control method [0: keyboard, 1: gamepad, 2: second gamepad(untested)]
var ctpf                = ["kb_", "gp_", "gp2_"] # list of prefixes for control methods
export var print_events = false

# Kinematics
var motion               = Vector2(0, 0)
# -> HORIZONTAL
var direction            = 0 # Directional coefficient
export var def_spd       = 1 # The default horizontal speed
export var reload_slow   = .25 # Speed multiplier on reload
var speed                = 0 

# -> JUMPING
export var gravity     = 0.1 # The acceleration per frame
export var jumpVel     = 2.0 # Instantaneous velocity at jump
var y_vel              = 0   # Current target vertical motion
var grounded           = false

# -> DASH
var dashing            = false
var dsh_dir
var dsh_dur
var dsh_vel

# Status
# -> HEALTH
export var ppos       = 0
export var immune     = false
var imm_dur           = 0
export var health     = 100
export var max_health = 100

export var dead       = false 

export var dead_gun   = preload("res://Prefab_Scenes/DeadGun.tscn") # Gun dropped by player on death
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
		
	if print_events:
		print (event)



var fframe = true
func _physics_process(dT):
	var scale_dir = 0
	
	var x = position.x
	var y = position.y

	if fframe: # Only run on first frame
	
		# Show player lobby positions "P1, P2, P3 etc.."
		print ("[PLAYER] ", get_name(), " is player ", ppos)
		
		var plr_indr
		
		if ppos == 1:
			plr_indr = load("res://Prefab_Scenes/Text_Resources/P1_inicator.tscn").instance()
		if ppos == 2:
			plr_indr = load("res://Prefab_Scenes/Text_Resources/P2_inicator.tscn").instance()
		
		add_child(plr_indr)
		plr_indr.position = Vector2(0, -12)
		 
		fframe = false


	if y - 5 > windowSize.y: # Out of bounds (Fallen off map)
		hurt(health, 0, 0) # Kill player
		
	motion.y += gravity
	
	if enabled:

		#HORIZONTAL KINEMATICS
		if (Input.is_action_pressed(str(ctpf[control_m]) + "left")):
			direction = -1 
			container.scale = Vector2(-1, 1) # Flip only objects in container where direction matters
			spt.flip_h = true

		elif (Input.is_action_pressed(str(ctpf[control_m]) + "right")):
			direction = 1
			container.scale = Vector2(1, 1) # Flip only objects in container where direction matters
			spt.flip_h = false

		else: 
			direction = 0 # This is only movement direction


		if (Input.is_action_pressed(str(ctpf[control_m]) + "jump")):
			if grounded:
				motion.y = -jumpVel

		motion.x = direction * def_spd #* dT # Final movement value

	# Reload indicator
	if shooter.reloading:
		rld_anim.show()
	else:
		rld_anim.hide()

	if health <= 0:
		print ("[PLAYER] ", get_name(), " is fuckin' dead holy shit")
		
		# Drop gun
		var nD_gun = dead_gun.instance()
		get_node("/root/World").add_child(nD_gun)
		nD_gun.get_node("Sprite").modulate = spt.mod # Set gun color to the color of the player
		nD_gun.position = position 
		
		get_parent().respawn(self)
		queue_free() # Destroy self

# THIS DOESN'T WORK YET. PLEASE DON'T LOOK.
#	if immune:
#		imm_dur -= dT
#		if imm_dur <= 0:
#			immune = false
#			print ("[PLAYER] ", get_name, " can now be hurt.")

	motion = move_and_slide(motion) # The normal move() function would create too much friction


# PAIN AND SUFFERING
func hurt(damage, dir, punch):
	#print ("[PLAYER] ", name, " took ", damage, " damage")
	move_and_collide (Vector2(dir * punch, 0)) # Knockback

	spt.blink(0.1) # Flash

	health -= damage


# THIS DOESN'T WORK YET, PLEASE DON'T LOOK.
#func immunize (duration):
#	immune = true
#	imm_dur = duration
#	print ("[PLAYER] ", get_name(), " is immune for ", duration, " seconds.")


# Colliders & Triggers
func _on_Area2D_body_enter (body):
	if body != self:
		grounded = true



func _on_Area2D_body_exit (body):
	grounded = false
