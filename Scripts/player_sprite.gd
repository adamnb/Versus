extends Sprite

var def_spt
var duration = 0.0
var blink_spt = preload("res://Textures/soldier88flash.tex")

func _ready():
	set_process(true)
	
	set_texture(def_spt)
	
func _process(dT):
	if duration > 0:
		# Count down and set sprite to flash
		duration -= dT 
		set_texture(blink_spt)
	
	else: # Time runs out
		duration = 0
		set_texture(def_spt) # Return to regular sprite

func blink (dur):
	duration = dur
	