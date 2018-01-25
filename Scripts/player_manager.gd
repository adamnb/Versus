extends Node

var players = [] # Instances of players
var cur_players = [] 

export(int) var respawn_time = 2
var respawn_queue = []

func _ready():
	for c in get_children():
		players.append(c.duplicate())

	print ("[PLAYER MANAGER] Initialized with ", players.size(), " players")
	print ("[PLAYER MANAGER] Players: ", players)
	
	set_process(true)
	
func _process(dT):
	for p in respawn_queue:
		p[1] -= dT
		
		if !p[1]:
			#respawn
			pass
		
func respawn (player):
	print ("I was asked to respawn ", player.get_name(), " but I don't like him so I wont.")
	respawn_queue.append([player, respawn_time])
	
	