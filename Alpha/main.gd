extends Node3D

#variables for controlling the inputs
var is_listening_laughing = false
var laughing_temp_listening_time = 0
var is_listening_crying = false
var crying_temp_listening_time = 0
var laughing_temp_looking_time = 0
var crying_temp_looking_time = 0
var arguing = true
var laughing_con_seconds = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$arguing/bg_arguing_sound_fx.play()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if(!arguing):
	#	$arguing/bg_arguing_sound_fx.stop()
	#else:
	#	$arguing/bg_arguing_sound_fx.play()
	#t_listening_laughing
	if (is_listening_laughing == true&& ($laughing/looking_at.looking_at_me)):
		Globals.t_listening_laughing += delta
		
	#t_listening_crying
	if (is_listening_crying== true && ($CRYING/looking_at.looking_at_me)):
		Globals.t_listening_crying += delta
	#t_looking_laughing
	if($laughing/looking_at.looking_at_me == true):
		Globals.t_looking_laughing += delta
	#t_looking_crying
	if($CRYING/looking_at.looking_at_me == true):
		Globals.t_looking_crying += delta
	#need to think about better definition
	if(($player.is_idle == true)):
		Globals.t_idle += delta
	if($CRYING.player_is_talking == true):
		Globals.t_talking_crying+=delta
	
	$timers/crying.text = str(Globals.first_interaction)
		

func insert_data():
	var collection: FirestoreCollection = Firebase.Firestore.collection("experiment")
	var data: Dictionary = {
	"logs": Globals.logs,
	"q_asked": Globals.q_asked,
	"t_listening_laughing": Globals.t_listening_laughing,
	"t_listening_crying": Globals.t_listening_crying,
	"distance_travelled": Globals.distance_travelled,
	"non_curious_interactions": Globals.non_curious_interactions,
	"t_looking_laughing": Globals.t_looking_laughing,
	"t_looking_crying": Globals.t_looking_crying,
	"t_idle": Globals.t_idle,
	"first_interaction": Globals.first_interaction,
	"t_talking_crying": Globals.t_talking_crying
	}
	await collection.add(Globals.id, data)
	print("added")

#listening to crying time
######
func _on_crying_listening_body_entered(body):
	if(body.name == "player"):
		print("oh yes crying")
		is_listening_crying = true 
		Globals.logs.append("{" + "'begin_listen_Beb" + "': " + str(180-$endgame.time_left)+"}")


func _on_crying_listening_body_exited(body):
	if(body.name == "player"):
		is_listening_crying = false
		#Globals.t_listening_crying += crying_temp_listening_time
		crying_temp_listening_time = 0
		Globals.logs.append("{" + "'exit_listen_Beb" + "': " + str(180-$endgame.time_left)+"}")
#####


#listening to laughing time
####
func _on_laughing_listening_body_entered(body):
	if(body.name == "player"):
		print("oh yes crying")
		is_listening_laughing = true
		$laughing/conv.play(laughing_con_seconds) 
		$laughing/laughter.volume_db = -50
		Globals.logs.append("{" + "'begin_listen_Girls" + "': " + str(180-$endgame.time_left)+"}")


func _on_laughing_listening_body_exited(body):
	if(body.name == "player"):
		is_listening_laughing = false
		#Globals.t_listening_laughing += laughing_temp_listening_time
		laughing_temp_listening_time = 0
		laughing_con_seconds = $laughing/conv.get_playback_position() 
		$laughing/conv.stop()
		$laughing/laughter.volume_db = 50
		Globals.logs.append("{" + "'exit_listen_Girls" + "': " + str(180-$endgame.time_left)+"}") 
####


func _on_endgame_timeout():
	await insert_data() 
	$Ending.visible = true


func _on_robot_continute_arg(continute):
	$arguing/bg_arguing_sound_fx.playing = continute


func _on_arguing_listening_body_entered(body):
	if(body.name == "player"):
		Globals.logs.append("{" + "'begin_listen_Arguing" + "': " + str(180-$endgame.time_left)+"}")


func _on_arguing_listening_body_exited(body):
	if(body.name == "player"):
		Globals.logs.append("{" + "'exit_listen_Arguing" + "': " + str(180-$endgame.time_left)+"}")
