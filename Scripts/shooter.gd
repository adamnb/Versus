extends Position2D

onready var flash_spt   = find_node("Flash")
export var flash_offset = Vector2(0, 0)

var proj = preload("res://Prefab_Scenes/Bullet.tscn") # Projectile prefab
var dir  = 1 # Firing direction (-1, 1)


onready var control_m = get_parent().get_parent().control_m  # Control mode of player
onready var ctpf      = get_parent().get_parent().ctpf       # Control prefixes

# MUNITIONS
export var chamber_dur  = 0.25 # How long it takes to chamber a round
export(int) var mag_max = 30 # Maximum ammo that can be stored in a magazine
export var reload_s     = 1.5 # How long it takes for the player to reload (s) 
var cur_ammo
var reloading = false
var cur_rl_t  = 0 # Elapsed time since reload call
var cur_t     = 0 # Elipsed time since gun fired

func _ready():
	set_process_input(true)
	set_process(true)

	cur_ammo = mag_max

func _input(event):
	if (cur_ammo < mag_max):
		if (event.is_action_pressed(str(ctpf[control_m]) + "reload")):
			reloading = true



func _process(dT):
	var p_dir = get_parent().get_parent().direction # The parent's movement direction (-1, 0, 1)

	# "dir = p_dir" makes it so when the player isn't moving, it aims nowhere, and will fire a bullet with no direction
	if p_dir == -1:
		dir = -1
	if p_dir == 1:
		dir = 1

	# Reset muzzleflash sprite
	if flash_spt:
		flash_spt.set_texture(null)


	if cur_ammo > 0:
		if (cur_t <= 0): # Chambered
			if (Input.is_action_pressed(str(ctpf[control_m]) + "fire")):

				var nShot = proj.instance() # Create clone instance
				get_node("/root/World").add_child(nShot) # Add to tree
				nShot.get_child(0).position = global_position # Reposition

				nShot.get_child(0).dir = dir # Movement dir
				
				cur_ammo -= 1

				flash_spt.flash(0.05) # Muzzle flash

				cur_t = chamber_dur

	else:
		reloading = true
		
	if (cur_ammo < mag_max):
		if (Input.is_action_pressed(str(ctpf[control_m]) + "reload")):
			reloading = true
	
	if cur_t > 0:
		cur_t -= dT
	else:
		cur_t = 0

	if reloading:
		reload(dT)



func reload (delta):
	cur_rl_t += delta

	if cur_rl_t > reload_s:
		cur_ammo = mag_max
		cur_rl_t = 0
		reloading = false
