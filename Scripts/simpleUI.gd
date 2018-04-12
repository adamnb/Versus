extends Node2D

export var show_fps  = true

# Health Bar
export var height    = -5
export var width     = 8
export var x_offset  = 3
export var thickness = 1.0

export(Font) var font# = DynamicFont.new()

var playerContainer

func _ready():
	playerContainer = get_parent().find_node("Players")
	set_process(true)

	var data = DynamicFontData.new()
	data.set_font_path("res://Prefab_Scenes/Fonts/cour.fnt")
	#font.set_font_data(data)
	#font.set_size(5)

func _draw():
	for c in playerContainer.get_children():
		#please forgive me DRY
		
		var bullet_src = c.get_node("ElementContainer").get_node("BulletSource")
		
		# HEALTH
		# - MASK
		draw_line(
		Vector2(c.position.x - x_offset, c.position.y + height), 
		Vector2(c.position.x + width - x_offset, c.position.y + height), 
		Color(1, 0, 0), # The fuggin brightest possible red
		thickness)

		# - BAR
		draw_line(
		Vector2(c.position.x - x_offset, c.position.y + height), 
		Vector2(c.position.x + (width*(c.health/100)) - x_offset, c.position.y + height), 
		Color(0, 1, 0), # The fuggin brightest possible green
		thickness)
		
		# AMMO
		var ammo_quot  = float(bullet_src.cur_ammo) / float(bullet_src.mag_max)
		var ammo_col_n = Color(1, 0.71, 0.25)
		var ammo_col_l = Color(1, 0, 0)
		var ammo_col   = Color(0)
		
		# Color changing
		if ammo_quot <= 0.3: # Ammo < 30%
			ammo_col = ammo_col_l # change to red
		else:
			ammo_col = ammo_col_n
		
		# - MASK
		draw_line(
		Vector2(c.position.x - x_offset, c.position.y + height + 1), 
		Vector2(c.position.x + width - x_offset, c.position.y + height + 1), 
		Color(0.5, 0.5, 0.5), # Mid grey
		thickness)
		
		# - BAR
		draw_line(
		Vector2(c.position.x - x_offset, c.position.y + height + 1), 
		Vector2(c.position.x + (width * ammo_quot) - x_offset, c.position.y + height + 1),
		ammo_col, # T
		thickness)
		
	
	#draw_string(font, Vector2(30, 30), str("Wheeeee"), Color(1, 1, 1))

func _process(dT):
	update()