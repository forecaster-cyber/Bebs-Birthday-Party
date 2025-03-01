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
var girls_done_talking = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$arguing/PATH_arg2/PathFollow3D/arg2/bg_arguing_sound_fx.play()
	Globals.highlights = get_node("highlights")
	Globals.highlights_distractions = get_node("highlights/highlights_distractions")
	Globals.highlights_npc = get_node("highlights/highlights_npc")
	Globals.connect("highlight_actions_now", _on_highlight_objects)
	Globals.connect("hide_arrows", _on_hide_arrows)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_hide_arrows():
	var arrows = get_node("highlights").get_children()
	for arrow in arrows:
		arrow.visible = false
	Globals.highlight_question = false
	Globals.highlight_trick = false
	
func _on_highlight_objects(actions):
	Globals.p_logs.append("{" + str(Globals.p_is_curious) + "': " + str(360-$endgame.time_left)+"}")
	$highlights.visible = true
	match actions[0]:
		"ask_question_beb":
			var arrow_node = get_node("highlights/enter_listen_bubble_beb")
			arrow_node.visible = true
			Globals.highlight_question_signal.emit(true)
			print("question beb " + str(Globals.highlight_question))
		"ask_question_arguing":
			var arrow_node = get_node("highlights" + str("/") + "enter_listen_bubble_arguing")
			arrow_node.visible = true
			Globals.highlight_question_signal.emit(true)
			print("question arguing")
		"trick_beb":
			var arrow_node = get_node("highlights" + str("/") + "enter_listen_bubble_beb")
			arrow_node.visible = true
			Globals.highlight_trick = true
			print("trick beb")
		"trick_arguing":
			var arrow_node = get_node("highlights" + str("/") + "enter_listen_bubble_arguing")
			arrow_node.visible = true
			Globals.highlight_trick = true
			print("trick arguing")
		var arrow:
			var arrow_node = get_node("highlights" + str("/") + arrow)
			Globals.highlight_question_signal.emit(false)
			Globals.highlight_trick_signal.emit(false)
			arrow_node.visible = true
	match actions[1]:
		"ask_question_beb":
			var arrow_node = get_node("highlights" + str("/") + "enter_listen_bubble_beb")
			arrow_node.visible = true
			Globals.highlight_question_signal.emit(true)
			print("question beb")
		"ask_question_arguing":
			var arrow_node = get_node("highlights" + str("/") + "enter_listen_bubble_arguing")
			arrow_node.visible = true
			Globals.highlight_question_signal.emit(true)
			print("question arguing")
		"trick_beb":
			var arrow_node = get_node("highlights" + str("/") + "enter_listen_bubble_beb")
			arrow_node.visible = true
			Globals.highlight_trick_signal.emit(true)
			print("trick beb")
		"trick_arguing":
			var arrow_node = get_node("highlights" + str("/") + "enter_listen_bubble_arguing")
			arrow_node.visible = true
			Globals.highlight_trick_signal.emit(true)
			print("trick arguing")
		var arrow:
			var arrow_node = get_node("highlights" + str("/") + arrow)
			Globals.highlight_question_signal.emit(false)
			Globals.highlight_trick_signal.emit(false)
			arrow_node.visible = true
			
	print("GOGO " + str(actions[0] +" "+ str(actions[1])))
	
func _process(delta):
	
	if(girls_done_talking):
		$laughing/PATH_g0/PathFollow3D.progress += delta
		$laughing/PATH_g1/PathFollow3D.progress += delta
		$laughing/PATH_g2/PathFollow3D.progress += delta
	#if(!arguing):
	#	$arguing/bg_arguing_sound_fx.stop()
	#else:
	#	$arguing/bg_arguing_sound_fx.play()
	#t_listening_laughing
	if (is_listening_laughing == true&& ($laughing/looking_at.looking_at_me)):
		Globals.t_listening_laughing += delta
		
	#t_listening_crying
	if (is_listening_crying== true && ($PATH_beb/PathFollow3D/CRYING/looking_at.looking_at_me)):
		Globals.t_listening_crying += delta
	#t_looking_laughing
	if($laughing/looking_at.looking_at_me == true):
		Globals.t_looking_laughing += delta
	#t_looking_crying
	if($PATH_beb/PathFollow3D/CRYING/looking_at.looking_at_me == true):
		Globals.t_looking_crying += delta
	#need to think about better definition
	if(($player.is_idle == true)):
		Globals.t_idle += delta
	if($PATH_beb/PathFollow3D/CRYING.player_is_talking == true):
		Globals.t_talking_crying+=delta
	
	$timers/crying.text = str(Globals.first_interaction)
	if (Globals.isTalking):
		$exit.visible = true
	else:
		$exit.visible = false
		

func insert_data():
	var collection: FirestoreCollection = Firebase.Firestore.collection("t3")
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
	"t_talking_crying": Globals.t_talking_crying,
	"age": Globals.age,
	"gender": Globals.gender,
	"is_dynamic": Globals.is_dynamic_game,
	"p_logs": Globals.p_logs
	}
	await collection.add(str(Globals.id), data)
	print("added")

#listening to crying time
######
func _on_crying_listening_body_entered(body):
	if(body.name == "player"):
		print("oh yes crying")
		is_listening_crying = true 
		Globals.logs.append("{" + "'begin_listen_Beb" + "': " + str(360-$endgame.time_left)+"}")
		$distractions/Radio/bday_music.stream_paused = true
		Globals.perform_action("enter_listen_bubble_beb")
		_on_hide_arrows()


func _on_crying_listening_body_exited(body):
	if(body.name == "player"):
		is_listening_crying = false
		#Globals.t_listening_crying += crying_temp_listening_time
		$distractions/Radio/bday_music.stream_paused = false
		crying_temp_listening_time = 0
		Globals.logs.append("{" + "'exit_listen_Beb" + "': " + str(360-$endgame.time_left)+"}")
		Globals.highlight_actions()
#####


#listening to laughing time
####
func _on_laughing_listening_body_entered(body):
	if(body.name == "player"):
		print("oh yes crying")
		is_listening_laughing = true
		$laughing/conv.play(laughing_con_seconds) 
		$laughing/laughter.volume_db = -50
		$distractions/Radio/bday_music.stream_paused = true
		$laughing/laughter.stream_paused = true
		Globals.logs.append("{" + "'begin_listen_Girls" + "': " + str(360-$endgame.time_left)+"}")
		Globals.perform_action("enter_listen_bubble_girls")
		_on_hide_arrows()


func _on_laughing_listening_body_exited(body):
	if(body.name == "player"):
		is_listening_laughing = false
		#Globals.t_listening_laughing += laughing_temp_listening_time
		laughing_temp_listening_time = 0
		laughing_con_seconds = $laughing/conv.get_playback_position() 
		$laughing/conv.stop()
		$laughing/laughter.volume_db = 50
		$distractions/Radio/bday_music.stream_paused = false
		$laughing/laughter.stream_paused = false
		Globals.logs.append("{" + "'exit_listen_Girls" + "': " + str(360-$endgame.time_left)+"}")
		Globals.highlight_actions() 
####


func _on_endgame_timeout():
	await insert_data() 
	$Ending.visible = true
	$distractions/Radio/bday_music.stream_paused = true
	$laughing/laughter.stream_paused = true
	$arguing/PATH_arg2/PathFollow3D/arg2/bg_arguing_sound_fx.stream_paused = true
	$laughing/conv.stream_paused = true
	$Ending/Button.uri = "https://tauindeng.eu.qualtrics.com/jfe/form/SV_6m6rYfSPWzZkfPg" + "?PlayerID=" + str(Globals.id)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_robot_continute_arg(continute):
	$arguing/PATH_arg2/PathFollow3D/arg2/bg_arguing_sound_fx.playing = continute


func _on_arguing_listening_body_entered(body):
	if(body.name == "player"):
		Globals.logs.append("{" + "'begin_listen_Arguing" + "': " + str(360-$endgame.time_left)+"}")
		$distractions/Radio/bday_music.stream_paused = true
		$laughing/laughter.stream_paused = true
		Globals.perform_action("enter_listen_bubble_arguing")
		_on_hide_arrows()


func _on_arguing_listening_body_exited(body):
	if(body.name == "player"):
		Globals.logs.append("{" + "'exit_listen_Arguing" + "': " + str(360-$endgame.time_left)+"}")
		$distractions/Radio/bday_music.stream_paused = false
		$laughing/laughter.stream_paused = false
		Globals.highlight_actions()


func _on_texture_button_pressed():
	$player.position = Vector3($player.position.x+ 0,$player.position.y+ 0,$player.position.z+ -1)


func _on_progress_talker_timeout():
	print("current  t " + str(Globals.current_talker))
	Globals.current_talker = (Globals.current_talker + 1) % 3

	# Update the characters' behavior based on `Globals.current_talker`
	match Globals.current_talker:
		0:
			$laughing/PATH_g1/PathFollow3D/g1.stop_stalking()
			$laughing/PATH_g2/PathFollow3D/g2.stop_stalking()
			$laughing/PATH_g0/PathFollow3D/g0.start_stalking()
			print("talking now:::: g0")
		1:
			$laughing/PATH_g0/PathFollow3D/g0.stop_stalking()
			$laughing/PATH_g2/PathFollow3D/g2.stop_stalking()
			$laughing/PATH_g1/PathFollow3D/g1.start_stalking()
			print("talking now:::: g1")
		2:
			$laughing/PATH_g0/PathFollow3D/g0.stop_stalking()
			$laughing/PATH_g1/PathFollow3D/g1.stop_stalking()
			$laughing/PATH_g2/PathFollow3D/g2.start_stalking()
			print("talking now:::: g2")
		
	


func _on_conv_finished():
	$laughing/PATH_g1/PathFollow3D/g1.stop_stalking()
	$laughing/PATH_g0/PathFollow3D/g0.stop_stalking()
	$laughing/PATH_g2/PathFollow3D/g2.stop_stalking()
	$laughing/PATH_g1/PathFollow3D/g1.walk()
	$laughing/PATH_g1/PathFollow3D/g1.look_at($Door.global_position)
	$laughing/PATH_g2/PathFollow3D/g2.walk()
	$laughing/PATH_g2/PathFollow3D/g2.look_at($Door.global_position)
	$laughing/PATH_g0/PathFollow3D/g0.walk()
	$laughing/PATH_g0/PathFollow3D/g0.look_at($Door.global_position)
	$laughing/laughter.stop()
	girls_done_talking = true
	
	
	
	
	
	
	



