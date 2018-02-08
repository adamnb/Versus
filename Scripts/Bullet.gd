extends KinematicBody2D

export var speed = 10
var dir          = 1 # Horizontal Direction

export var damage = 12.5
export var punch  = 1

var impact_flash  = preload("res://Prefab_Scenes/WhiteFlash66.tscn")

var res = Vector2(ProjectSettings.get("display/window/width"), ProjectSettings.get("display/window/height"))

func _ready():
	set_physics_process(true)

	find_node("Area2D").connect("body_entered", self, "_on_body_enter")

var firstFR = true # The first frame of the "_process()" function
func _physics_process(dT):

	var x = position.x
	var y = position.y
	

	move_and_collide(Vector2(dir*speed, 0))

	if x <= 0 || x > res.x || y < 0 || y > res.y: # Out of bounds
		queue_free()

func _on_body_enter (body):

	if body.get_script() != null:
		if 'health' in body: # Check if health variable is in collision body script. ( Really hacky way of verifying a script. I don't know of any other way :[ )
			body.hurt(damage, dir, punch)

	var nIF = impact_flash.instance() # Create a new instance of the impact flash
	get_node("/root/World").add_child(nIF) # Add it to the tree as a node
	nIF.position = position # Reposition

	get_parent().queue_free()
	
