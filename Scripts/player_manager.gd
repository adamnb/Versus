extends Node

var player_c = 0

var respawns = [] # List of respawn points
export(int) var respawn_time = 10
var respawn_queue = [] # All players that are dead and waiting to be respawned

export var inital_points = 5
var scores = []

func _ready():
	for c in get_children(): # Get list of all players and give them points
		scores.append([c.get_name(), inital_points])
		player_c += 1
		
	for r in get_parent().get_children(): # Get all respawn points
		if r.get_name().begins_with("resp"):
			respawns.append(r)

	print ("[PLAYER MANAGER] Initialized with ", player_c, " players")
	print ("[PLAYER MANAGER] Initialized with ", respawns.size(), " spawnpoints")
	
	set_process(true)



func _process(dT):
	
	var doomed = null
	var i = 0
	for p in respawn_queue:
		p[1] -= dT # Countdown remaining time in seconds
			
		if p[1] <= 0: # Time is up
				
			var nP = p[0]
			add_child(nP)
			
			var respawn_ind = rand_range(0, respawns.size()) # Random Index of all spawnpoints
			nP.position = Vector2(respawns[respawn_ind].position.x, 
				respawns[respawn_ind].position.y) # Set player position to chosen spawnpoint
			
			doomed = i
			break
				
		i += 1
	
	if doomed != null:
		respawn_queue.remove(doomed)


func respawn (player):
	for p in scores:
		if p[0] == player.get_name():
			p[1] -= 1
	
	#print ( "[PLAYER MANAGER] ", scores)
	
	respawn_queue.append([player.duplicate(), respawn_time])
	
