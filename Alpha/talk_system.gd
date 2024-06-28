extends Control

var questions
var dataFile
var parsed_json
var q_choices_array = [33,33,33]
var q_prob
var q_remaning =[4,3,3]
var initial_num_q = 0
signal update_prob(prob_arr)
# Called when the node enters the scene tree for the first time.
func _ready():
	print(questions)
	print()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _on_first_mouse_entered():
	dataFile = FileAccess.open(str(questions), FileAccess.READ)
	parsed_json = JSON.parse_string(dataFile.get_as_text())
	$AnimationPlayer.play("go_down")
	$dialog_sqr/text.text = parsed_json["questions"][q_remaning-1]["q"]
	print(q_remaning)
	print(q_remaning-1)




func _on_first_pressed():
	$dialog_sqr/text.text = parsed_json["questions"][q_remaning-1]["r"]
	#initial_num_q+=1
	#q_prob[q_choices_array[0]] -= 10
	#q_prob[q_choices_array[1]] += 5
	#q_prob[q_choices_array[2]] += 5
	if( q_remaning -1 < 0):
		q_remaning =initial_num_q
		#initial_num_q = 0
	else:
		q_remaning = q_remaning -1
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
