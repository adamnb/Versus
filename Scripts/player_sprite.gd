extends Sprite

var def_spt
var duration = 0.0
var blink_spt = preload("res://Textures/soldier88flash.tex")

export(bool) var randomize_col = true
export(bool) var random_alpha = false

var mod

func _ready():
	set_process(true)
	
	set_texture(def_spt)
	
	if randomize_col:
		print ("[PLAYER SPRITE] colors are randomized")
		
		var r = rand_range(0, 1)
		var g = rand_range(0, 1)
		var b = rand_range(0, 1)
		var a = 1.0
		
		if random_alpha:
			a = rand_range(0, 1)
			
		mod = Color(r,g,b,a)

	set("modulate", mod)
		
func _process(dT):
	if duration > 0:
		# Count down and set sprite to flash
		duration -= dT 
		set_texture(blink_spt)
		set("modulate", Color("#FFFFFF"))
	
	else: # Time runs out
		duration = 0
		set_texture(def_spt) # Return to regular sprite
		set("modulate", mod)

func blink (dur):
	duration = dur
	