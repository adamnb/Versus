extends Sprite

var duration = 0.0  # The amout of frames a flash will be displayed. Set with flash() func
#var cur_f = 0 # Current elapsed frames since assigned texture

# An array of all the gun flash textures
var flashes =  [preload("res://Textures/gunflash0.tex"), 
				preload("res://Textures/gunflash1.tex"), 
				preload("res://Textures/gunflash2.tex")]
				
var cur_tex

var x
var y

func _ready():
	set_process(true)
	
	
func _process(dT):
	
	x = get_global_pos().x
	y = get_global_pos().y
	
	if duration > 0:
		duration -= dT
		set_texture(cur_tex)
		
	else:
		duration = 0
		set_texture(null)
		
	
func flash(dur):
	duration = dur # Set requested duration
	cur_tex = flashes[rand_range(0, flashes.size())] # Set the texture to a random flash
	