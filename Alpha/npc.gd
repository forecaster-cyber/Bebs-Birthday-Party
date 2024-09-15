extends Node3D
@export var player: Node3D
var player_close = false
@export var questions_path: String
@export var can_talk: bool
@export var npc: Node3D

# Called when the node enters the scene tree for the first time.
var rng = RandomNumberGenerator.new()
var random_talk_speed = rng.randf_range(0.0,0.2)
var red = rng.randf_range(0.5,1.0)
var green = rng.randf_range(0.4,1.0)
var blue = rng.randf_range(0.3,1.0)
var num_of_q = 0
var player_is_talking = false
signal lock_rotation(lock)
var talking_now = false

#signal q_choices(q1,q2,q3)
#signal q_prob(q_prob_arr)
signal num_of_questions_remaining(num_of_questions)
func _ready():
	
	
	var material = $Body.get_active_material(0).duplicate()
	material.albedo_color = Color(red, green, blue)
	$Body.set_surface_override_material(0, material)
	$talk_system.questions = questions_path
	$talk_system.npc = self
	$talk_system.other_npc = player
	var dataFile = FileAccess.open(str(questions_path), FileAccess.READ)
	var parsed_json = JSON.parse_string(dataFile.get_as_text())
	num_of_q = parsed_json["questions"].size()
	num_of_questions_remaining.emit(num_of_q)
	#$talk_system.initial_num_q = num_of_q
	if (!can_talk):
		$AnimationPlayer.play("talking")
		$AnimationPlayer.speed_scale -= random_talk_speed
		talking_now = true
	else:
		$AnimationPlayer.play("crying")
		$Body/AnimatedSprite3D.stop()
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(!talking_now):
		$Body/AnimatedSprite3D.stop()
	else:
		$Body/AnimatedSprite3D.play()
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
		lock_rotation.emit(false)
		player_is_talking = true
		#var player_cam_translation = player.get_node("head/cam").position
		#$npc_cam.position = player_cam_translation
		$npc_cam.set_current(true)




func _on_npc_collision_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if(area.name == "looking_at"):
		if (can_talk):
			$Label3D.visible = true
			player_close = true


func _on_npc_collision_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if(area.name == "looking_at"):
		$Label3D.visible = false
		player_close = false 
		$talk_system.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		lock_rotation.emit(true)
		$npc_cam.set_current(false)
		player.visible = true

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
	





func _on_talk_system_play_mouth_anim_self(talking):
	talking_now = talking # Replace with function body.


func _on_talk_system_play_distraction():
	var random = rng.randf_range(0,1.0)
	if(random > 0.5):
		$AnimationPlayer.speed_scale = random*2
		$AnimationPlayer.play("dis1")
		
	else:
		$AnimationPlayer.speed_scale = random*4
		$AnimationPlayer.play("dis2")
	
