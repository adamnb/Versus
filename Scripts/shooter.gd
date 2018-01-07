extends Position2D

onready var flash_spt = find_node("Flash")

var proj = preload("res://Prefab_Scenes/Bullet.tscn") # Projectile prefab
var dir  = 1 # Firing direction (-1, 1)


onready var control_m = get_parent().control_m  # Control mode of player
onready var ctpf      = get_parent().ctpf       # Control prefixes

func _ready():
	set_process_input(true)
	set_process(true)

	
func _process(dt):
	var p_dir = get_parent().direction # The parent's movement direction (-1, 0, 1)
 	
	if p_dir == -1:
		dir = -1
	if p_dir == 1:
		dir = 1
		
	flash_spt.set_texture(null)
	
	
func _input(e): # Run only when input is recieved

	if (e.is_action_pressed(str(ctpf[control_m]) + "fire")):
		var nShot = proj.instance()
		get_parent().get_parent().add_child(nShot)
		nShot.get_child(0).set_pos(get_global_pos())
		
		nShot.get_child(0).dir = dir
		
		flash_spt.flash(3)