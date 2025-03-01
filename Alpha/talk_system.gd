extends Control

var questions
var dataFile
var parsed_json
#var q_choices_array = [33,33,33]
#var q_prob
var q_remaning =0
var initial_num_q = 0
var npc: Node3D
var other_npc: Node3D
signal play_mouth_anim_self(talking)
signal play_mouth_anim_other(talking)
signal play_distraction()
signal log_interaction(kind, time)
signal walk()
# Called when the node enters the scene tree for the first time.
func _ready():
	print(questions)
	print()
	Globals.connect("highlight_question_signal", _on_highlight_question)
	Globals.connect("highlight_trick_signal", _on_highlight_trick)
	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_first_pressed():
	print("initial qqqq" + str(initial_num_q))
	print("q_remaining" + str(q_remaning))
	$dialog_sqr.visible = true
	$first.visible = false
	$second.visible = false
	Globals.q_asked += 1
	var interaction_time = 0
	
	dataFile = FileAccess.open(str(questions), FileAccess.READ)
	parsed_json = JSON.parse_string(dataFile.get_as_text())
	play_mouth_anim_other.emit(true)
	$dialog_sqr/text.set("theme_override_colors/font_color", Color(other_npc.red, other_npc.green, other_npc.blue, 1.0))
	$dialog_sqr/text.text = parsed_json["questions"][initial_num_q]["q"]
	var audio1 = load(parsed_json["questions"][initial_num_q]["qAud"])
	if(audio1 != null):
		$dialog_sound.stream = audio1
		$dialog_sound.play()
		await get_tree().create_timer($dialog_sound.stream.get_length()).timeout
		interaction_time += await $dialog_sound.stream.get_length()
	else:
	#play sound, await till over
		await get_tree().create_timer(3.0).timeout
	play_mouth_anim_other.emit(false)
	play_mouth_anim_self.emit(true)
	$dialog_sqr/text.set("theme_override_colors/font_color", Color(npc.red, npc.green, npc.blue, 1.0))
	$dialog_sqr/text.text = parsed_json["questions"][initial_num_q]["r"]
	var audio = load(parsed_json["questions"][initial_num_q]["rAud"])
	$dialog_sound.stream = audio
	$dialog_sound.play()
	#play sound, await till over
	await get_tree().create_timer($dialog_sound.stream.get_length()).timeout
	interaction_time += await $dialog_sound.stream.get_length()
	log_interaction.emit("{" + "'ask_question" + "': ", interaction_time)
	play_mouth_anim_self.emit(false)
	initial_num_q+=1
	$dialog_sqr/text.text = ""
	$dialog_sqr.visible = false
	$first.visible = true
	$second.visible = true
	#q_prob[q_choices_array[0]] -= 10
	#q_prob[q_choices_array[1]] += 5
	#q_prob[q_choices_array[2]] += 5
	if( initial_num_q == q_remaning):
		#initial_num_q= 0
		walk.emit()
		#initial_num_q = 0
	if(other_npc.name == "arg2"):
		Globals.perform_action("ask_question_arguing")
	elif(other_npc.name == "player"):
		Globals.perform_action("ask_question_beb")
	#update_prob.emit(q_prob)
	







#func _on_npc_q_choices(q1, q2, q3):
#	q_choices_array[0]=q1
#	q_choices_array[1]=q2
#	q_choices_array[2]=q3
#	print(q_choices_array)
#	print("questions remaining for each catgory:" + str(q_remaning))




#func _on_npc_q_prob(q_prob_arr):
#	q_prob = q_prob_arr


func _on_npc_num_of_questions_remaining(num_of_questions):
	q_remaning =num_of_questions


func _on_second_pressed():
	$first.visible = false
	$second.visible = false
	
	play_distraction.emit()
	await get_tree().create_timer(3.0).timeout
	log_interaction.emit("{" + "'trigger_distraction" + "': ", 3.0)
	$first.visible = true
	$second.visible = true
	if(other_npc.name == "arg2"):
		Globals.perform_action("trick_arguing")
	elif(other_npc.name == "player"):
		Globals.perform_action("trick_beb")


func _on_robot_num_of_questions_remaining(num_of_questions):
	q_remaning =num_of_questions
func _on_highlight_question(show):
	$first/Arrow.visible = show
func _on_highlight_trick(show):
	$second/Arrow.visible = show
