extends Node

var players = [] # Instances of players

var respawns = []
export(int) var respawn_time = 10
var respawn_queue = []

func _ready():
	for c in get_children():
		players.append(c.duplicate())
		
	for r in get_parent().get_children():
		if r.get_name() == "Respawn":
			respawns.append(r)

	print ("[PLAYER MANAGER] Initialized with ", players.size(), " players")
	print ("[PLAYER MANAGER] Initialized with ", respawns.size(), " spawnpoints")
	print ("[PLAYER MANAGER] Players: ", players)
	
	
	set_process(true)

func _process(dT):
	
	#print ("[PLAYER MANAGER] ", respawn_queue)
	var doomed = null
	var i = 0
	for p in respawn_queue:
		p[1] -= dT
			
		if p[1] <= 0:
				
			var nP = p[0]
			add_child(nP)
			
			var respawn_ind = rand_range(0, respawns.size()-1) # Random Index of all spawnpoints
			nP.set_pos(Vector2(respawns[respawn_ind].get_pos().x, 
				respawns[respawn_ind].get_pos().y)) # Set player position to chosen spawnpoint
			
			doomed = i
			#print ("[PLAYER MANAGER] Doomed iter: ", doomed_i, " | Array: ", respawn_queue)
			break
				
		i += 1
	
	if doomed != null:
		respawn_queue.remove(doomed)
	
func respawn (player):
	print ("[PLAYER MANAGER] I was asked to respawn ", player.get_name(), " and I will fulfill that request because I am nice and intelligent.")
	respawn_queue.append([player.duplicate(), respawn_time])
