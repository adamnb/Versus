extends Node2D

export var show_fps = true

# Health Bar
export var height    = -5
export var width     = 8
export var x_offset  = 3
export var thickness = 1.0

var font = DynamicFont.new()

var playerContainer

func _ready():
	playerContainer = get_parent().find_node("Players")
	set_process(true)
	
	var data = DynamicFontData.new()
	data.set_font_path("res://Fonts/cour.fnt")
	font.set_font_data(data)
	font.set_size(5)

func _draw():
	for c in playerContainer.get_children():
		#please forgive me DRY
		
		# MASK
		draw_line(
		Vector2(c.get_pos().x - x_offset, c.get_pos().y + height), 
		Vector2(c.get_pos().x + width - x_offset, c.get_pos().y + height), 
		Color(1, 0, 0), # The fuggin brightest possible red
		thickness)
		
		# BAR
		draw_line(
		Vector2(c.get_pos().x - x_offset, c.get_pos().y + height), 
		Vector2(c.get_pos().x + (width*(c.health/100)) - x_offset, c.get_pos().y + height), 
		Color(0, 1, 0), # The fuggin brightest possible green
		thickness)
	
#	if show_fps:
#		draw_string(font, Vector2(1, 10), "Wheeeee", Color(1, 1, 1))

func _process(dT):
	update()