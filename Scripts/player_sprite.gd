extends Sprite

var def_spt
var duration = 0.0
var blink_spt = preload("res://Textures/soldier88flash.tex")

func _ready():
	set_process(true)
	
	def_spt = get_texture()
	
func _process(dT):
	if duration > 0:
		duration -= dT
		set_texture(blink_spt)
	
	else:
		duration = 0
		set_texture(def_spt)

func blink (dur):
	duration = dur
	