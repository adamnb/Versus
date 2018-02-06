extends Position2D

onready var flash_spt = get_node("Flash")

var proj = preload("res://Prefab_Scenes/Bullet.tscn") # Projectile prefab
var dir  = 1 # Firing direction (-1, 1)


onready var control_m = get_parent().control_m  # Control mode of player
onready var ctpf      = get_parent().ctpf       # Control prefixes

# MUNITIONS
export var mag_max     = 1000 # Maximum ammo that can be stored in a magazine
export var reload_s    = 1.5 # How long it takes for the player to reload (s) 
export var chamber_dur = 0.25 # How long it takes to chamber a round
var cur_t = 0
var cur_ammo

func _ready():
	set_process_input(true)
	set_process(true)
	
	cur_ammo = mag_max

	
func _process(dT):
	var p_dir = get_parent().direction # The parent's movement direction (-1, 0, 1)
 	
	if p_dir == -1:
		dir = -1
	if p_dir == 1:
		dir = 1
		
	if flash_spt:
		flash_spt.set_texture(null)
	
	if cur_ammo > 0:
		if (cur_t <= 0): # Chambered
			if (Input.is_action_pressed(str(ctpf[control_m]) + "fire")):

				var nShot = proj.instance() # Create clone instance
				get_parent().get_parent().get_parent().add_child(nShot) # Add to tree
				nShot.get_child(0).set_pos(get_global_pos()) # Reposition
				
				nShot.get_child(0).dir = dir # Movement dir
				
				cur_ammo -= 1
				
				flash_spt.flash(0.05) # Muzzle flash
				
				cur_t = chamber_dur
	
	if cur_t > 0:
		cur_t -= dT
	else:
		cur_t = 0
