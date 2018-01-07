extends Sprite

var duration  # The amout of frames a flash will be displayed. Set with flash() func
var cur_f = 0 # Current elapsed frames since assigned texture
var flashing = false

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
	
	if flashing:
		set_texture(cur_tex)
		cur_f += 1
	
	if cur_f == duration:
		flashing = false
		set_texture(null)
	
func flash(dur):
	duration = dur # Set requested duration
	cur_tex = flashes[rand_range(0, flashes.size())] # Set the texture to a random flash
	flashing = true 
	cur_f = 0 # Reset timer
	