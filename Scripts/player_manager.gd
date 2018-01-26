extends Node

var players = [] # Instances of players

var respawns = []
export(int) var respawn_time = 1000000
var respawn_queue = []

func _ready():
	for c in get_children():
		players.append(c.duplicate())
		
	for r in get_parent().get_children():
		if r.get_name() == "Respawn":
			respawns.append(r)

	print ("[PLAYER MANAGER] Initialized with ", players.size(), " players")
	print ("[PLAYER MANAGER] Players: ", players)
	
	set_process(true)
	
func _process(dT):
	if respawn_queue.size() > 0:
		#print ("[PLAYER MANAGER] ", respawn_queue)
		
		for p in respawn_queue:
			p[1] -= dT
			
			if p[1] <= 0:
				print ("[PLAYER MANAGER] ", respawn_queue)
				
				var nP = p[0].instance()
				add_child(nP)
				nP.set_pos(respawns[0])
	
func respawn (player):
	print ("[PLAYER MANAGER] I was asked to respawn ", player.get_name(), " but I don't like him and I'm stupid so I wont.")
	respawn_queue.append([player.duplicate(), respawn_time])
	print ("[PLAYER MANAGER] ", respawn_queue)
