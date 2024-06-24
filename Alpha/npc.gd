extends Node3D
@export var player: Node3D
var player_close = false
@export var questions_path: String
@export var can_talk: bool
# Called when the node enters the scene tree for the first time.
var options_prob = [33,33,33]
var num_of_q = 0
signal q_choices(q1,q2,q3)
signal q_prob(q_prob_arr)
signal num_of_questions_remaining(num_of_questions)
func _ready():
	$talk_system.questions = questions_path
	var dataFile = FileAccess.open(str(questions_path), FileAccess.READ)
	var parsed_json = JSON.parse_string(dataFile.get_as_text())
	num_of_q = parsed_json["questions"].size()
	num_of_questions_remaining.emit(num_of_q)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_just_pressed("interact") && player_close && can_talk):
		#print(options_prob)
		#var q1 = weightedRandomIndex(options_prob)
		#var q2 = weightedRandomIndex(options_prob)
		#var q3 = weightedRandomIndex(options_prob)
		#q_choices.emit(q1,q2,q3)
		#q_prob.emit(options_prob)
		#print(q1,q2,q3)
		$talk_system.visible = true
		player.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		#var player_cam_translation = player.get_node("head/cam").position
		#$npc_cam.position = player_cam_translation
		$npc_cam.set_current(true)




func _on_npc_collision_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if (can_talk):
		$Label3D.visible = true
		player_close = true


func _on_npc_collision_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	$Label3D.visible = false
	player_close = false 
	$talk_system.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$npc_cam.set_current(false)

#func weightedRandomIndex(weights: Array) -> int:
#	var totalWeight = 0
#	var weightSums = []
#	for weight in weights:
#		totalWeight += weight
#		weightSums.append(totalWeight)
#	var randomVal = randi() % totalWeight
#	var index = 0
#	for i in range(weights.size()):
#		if randomVal< weightSums[i]:
#			index = i
#			break
#	return index


#func _on_talk_system_update_prob(prob_arr):
#	options_prob = prob_arr
#	var q1 = weightedRandomIndex(options_prob)
#	var q2 = weightedRandomIndex(options_prob)
#	var q3 = weightedRandomIndex(options_prob)
#	q_choices.emit(q1,q2,q3)
#	q_prob.emit(options_prob)
#	print(options_prob)
	
