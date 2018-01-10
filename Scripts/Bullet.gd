extends KinematicBody2D

export var force = 100.0 # For RigidBody2D only. Delete when settled
export var speed = 10
var dir          = 1 # Horizontal Direction

export var damage = 12.5		
export var punch  = 1

var res = Vector2(Globals.get("display/width"), Globals.get("display/height"))

func _ready():
	set_fixed_process(true)
	
	find_node("Area2D").connect("body_enter", self, "_on_body_enter")

var firstFR = true # The first frame of the "_process()" function
func _fixed_process(dT):
	
	var x = get_pos().x
	var y = get_pos().y
	
#	if firstFR:
#		apply_impulse(Vector2(0,0), Vector2(force * dir, 0))
#		firstFR = false
	
	move (Vector2(dir*speed, 0))
	
	if x <= 0 || x > res.x || y < 0 || y > res.y:
		queue_free()
		
func _on_body_enter (body):

	if body.get_script() != null:
		if 'health' in body: # Check if health variable is in collision body script. ( Really hacky way of verifying a script. I don't know of any other way :[ )
			body.hurt(damage, dir, punch)
			
	get_parent().queue_free()
	