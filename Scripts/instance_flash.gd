extends Node

export var seconds    = true # Using seconds for timekeeping
export var duration_s = 0.06 # Existence duration for seconds
export var duration_f = 1    # Existence duration for frames

var cur_t

func _ready():
	set_process(true)
	
	if seconds:
		cur_t = duration_s
	else:
		cur_t = duration_f

func _process(dT):
	
	if seconds:
		cur_t -= dT
	else:
		cur_t -= 1
		
	if cur_t <= 0:
		queue_free()

