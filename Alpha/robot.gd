extends Node3D
@export var player: Node3D
var player_close = false
@export var questions_path: String
@export var can_talk: bool
# Called when the node enters the scene tree for the first time.
@export var npc: Node3D
@export var other_npc: Node3D
var num_of_q = 0
var player_is_talking = false
signal lock_rotation(lock)
var npc_talking = false
var was_talking = false
var other_npc_talking = false
var rng = RandomNumberGenerator.new()
signal num_of_questions_remaining(num_of_questions)
signal continute_arg(continute)
@export var timer: Timer
func _ready():
	$talk_system.questions = questions_path
	$talk_system.npc = npc
	$talk_system.other_npc = other_npc
	var dataFile = FileAccess.open(str(questions_path), FileAccess.READ)
	var parsed_json = JSON.parse_string(dataFile.get_as_text())
	num_of_q = parsed_json["questions"].size()
	print(str(num_of_q) + str("!!!!!!!!!!"))
	num_of_questions_remaining.emit(num_of_q)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(!npc_talking):
		npc.talking_now = false
	else:
		npc.talking_now = true
	if(!other_npc_talking):
		other_npc.talking_now = false
	else:
		other_npc.talking_now = true
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
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		lock_rotation.emit(false)
		player_is_talking = true
		#var player_cam_translation = player.get_node("head/cam").position
		#$npc_cam.position = player_cam_translation
		$npc_cam.set_current(true)
		continute_arg.emit(false)
		was_talking = true
		Globals.logs.append("{" + "'begin_talk_Arguing" + "': " + str(180-timer.time_left)+"}")
		Globals.isTalking = true







func _on_area_3d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if(area.name == "looking_at"):
		if (can_talk):
			$Label3D.visible = true
			player_close = true


func _on_area_3d_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if(area.name == "looking_at" && was_talking):
		$Label3D.visible = false
		player_close = false 
		$talk_system.visible = false
		#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		lock_rotation.emit(true)
		$npc_cam.set_current(false)
		continute_arg.emit(true)
		was_talking = false
		Globals.logs.append("{" + "'exit_talk_Arguing" + "': " + str(180-timer.time_left)+"}")
		Globals.isTalking = false
	elif(area.name == "looking_at"):
		$Label3D.visible = false
		player_close = false 



func _on_talk_system_play_mouth_anim_other(talking):
	other_npc_talking = talking


func _on_talk_system_play_mouth_anim_self(talking):
	npc_talking = talking


func _on_talk_system_play_distraction():
	var random = rng.randf_range(0,1.0)
	if(random > 0.5 && random < 0.6) :
		$AnimationPlayer.speed_scale = random*2
		$AnimationPlayer.play("dis3")
		$AudioStreamPlayer.pitch_scale = random*2
		$AudioStreamPlayer.play()
		
	elif (random <0.5 ):
		$AnimationPlayer.speed_scale = random*4
		$AnimationPlayer.play("dis4")
		$AudioStreamPlayer.pitch_scale = random*4
		$AudioStreamPlayer.play()
	else:
		$AnimationPlayer.speed_scale = random*3
		$AnimationPlayer.play("dis5")
		$AudioStreamPlayer.pitch_scale = random*3
		$AudioStreamPlayer.play()


func _on_talk_system_log_interaction(kind, time):
	Globals.logs.append(kind + str(180-timer.time_left)+ ",interaction_time: " + str(time) +  "}")
