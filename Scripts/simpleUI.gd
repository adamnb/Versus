extends Node2D

export var height 	= -6
export var width = 10
export var x_offset = 4

var playerContainer

func _ready():
	playerContainer = get_parent().find_node("Players")
	set_process(true)

func _draw():
	for c in playerContainer.get_children():
		draw_line(Vector2(c.get_pos().x - x_offset, c.get_pos().y + height),
			Vector2(c.get_pos().x + 8 - x_offset, c.get_pos().y + height),
			Color(1,0,0),
			1.0)
			
func _process(dT):
	update()
		
	
