extends Node


var player_close = false
var picked_up = false
@export var player_hand: Node3D
@export var logable: bool = true
@export var object: Node3D
@export var aura: Node3D
@export var can_pick_up: bool
@export var instructions_text: String = "Press E to Grab!"
@export var actions_text: String = "Press Left Mouse to interact!"
var last_pos: Vector3
@export var timer: Timer
func _ready():
	last_pos = object.global_position
	
	$poof_effect.hide()
	if(!can_pick_up):
		$instructions.texture = load("res://mouse.png")
	#$instructions.text = instructions_text
	#$instructions.texture = load("res://mouse.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#pick up
	if(Input.is_action_just_pressed("interact") && player_close && !picked_up && can_pick_up):
		if(player_hand.get_parent().first_pick == false):
			player_hand.get_parent().first_pick = true
			Globals.first_interaction = str(object.name)
		Globals.non_curious_interactions += 1
		if logable:
			Globals.logs.append("{" + "'grab_" + str(object.name) + "': " + str(360-timer.time_left)+", pos: (" + str(player_hand.global_position) + ")}")
			if(object.name == "Gun"):
				Globals.perform_action("distraction_gun")
			elif(object.name == "Gift"):
				Globals.perform_action("distraction_present")
		else:
			pass
		print("picked up")
		object.freeze = true
		last_pos = object.global_position
		object.global_position = player_hand.global_position
		object.global_rotation_degrees = Vector3(player_hand.global_rotation_degrees.x, player_hand.global_rotation_degrees.y+100,player_hand.global_rotation_degrees.z)
		object.reparent(player_hand)
		picked_up = true
		print(str(picked_up) + str("123"))
		#$instructions.text = actions_text
		$instructions.texture = load("res://mouse.png")
		$exit.visible = true
		aura.visible = false
		
	#drop
	elif(Input.is_action_just_pressed("interact") && player_close && picked_up):
		if logable:
			Globals.logs.append("{" + "'drop_" + str(object.name) + "': " + str(360-timer.time_left)+", pos: (" + str(player_hand.global_position) + ")}")
		else:
			pass
		object.reparent(get_tree().get_current_scene())
		object.freeze = false
		print("dropped")
		picked_up = false
		$exit.visible = false
		$instructions.texture = load("res://E.png")
		Globals.highlight_actions()
		
	elif(Input.is_action_just_pressed("activate") && player_close && (picked_up || !can_pick_up)):
		print("RAAAA L" + str(object.name))
		if(player_hand.get_parent().first_pick == false):
			player_hand.get_parent().first_pick = true
			Globals.first_interaction = str(object.name)
		Globals.non_curious_interactions += 1
		if logable:
			Globals.logs.append("{" + "'activate_" + str(object.name) + "': " + str(360-timer.time_left)+", pos: (" + str(player_hand.global_position) + ")}")
			if(object.name == "Radio"):
				Globals.perform_action("activate_radio")
				print("RAAAA B" )
				Globals.highlight_actions()
			elif(object.name == "Balloon"):
				Globals.perform_action("activate_balloon")
				print("RAAAA C" )
				Globals.highlight_actions()
			elif(object.name == "Gun"):
				Globals.perform_action("activate_gun")
				print("RAAAA A" )
				#Globals.highlight_actions()
			elif(object.name == "Gift"):
				Globals.perform_action("activate_present")
				print("RAAAA R" )
				#Globals.highlight_actions()
		else:
			pass
		object.action()
		print("action")
		aura.visible = false






func _on_area_3d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if(area.name == "looking_at"):
		player_close = true
		$instructions.visible = true
	elif(area.name == "floor_area"):
		print("sus!")
		$poof_effect.visible = true
		#object.visible = false
		$AnimationPlayer.play("poof")
		respawn()
	


func _on_area_3d_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if(area.name == "looking_at"):
		player_close = false
		$instructions.visible = false
		#Globals.highlight_actions()


func respawn():
	object.sleeping = true
	object.global_position = last_pos


func _on_animation_player_animation_finished(anim_name):
	$poof_effect.visible = false
	#object.visible = true


func _on_texture_button_pressed():
	if(player_close && picked_up):
			if logable:
				Globals.logs.append("{" + "'drop_" + str(object.name) + "': " + str(360-timer.time_left)+", pos: (" + str(player_hand.global_position) + ")}")
			else:
				pass
			object.reparent(get_tree().get_current_scene())
			object.freeze = false
			print("dropped")
			picked_up = false
			$instructions.texture = load("res://E.png")
			$exit.visible = false
			Globals.highlight_actions()
	else:
		pass
