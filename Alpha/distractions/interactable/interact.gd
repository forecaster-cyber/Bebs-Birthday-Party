extends Node


var player_close = false
var picked_up = false
@export var player_hand: Node3D
@export var object: Node3D
@export var can_pick_up: bool
@export var instructions_text: String = "Press E to Grab!"
@export var actions_text: String = "Press Left Mouse to interact!"
var last_pos: Vector3
func _ready():
	last_pos = object.global_position
	
	$poof_effect.hide()
	$instructions.text = instructions_text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#pick up
	if(Input.is_action_just_pressed("interact") && player_close && !picked_up && can_pick_up):
		if(player_hand.get_parent().first_pick == false):
			player_hand.get_parent().first_pick = true
			Globals.first_interaction = str(object.name)
		print("picked up")
		object.freeze = true
		last_pos = object.global_position
		object.global_position = player_hand.global_position
		object.reparent(player_hand)
		picked_up = true
		print(str(picked_up) + str("123"))
		$instructions.text = actions_text
		
	#drop
	elif(Input.is_action_just_pressed("interact") && player_close && picked_up):
		object.reparent(get_tree().get_current_scene())
		object.freeze = false
		print("dropped")
		picked_up = false
	elif(Input.is_action_just_pressed("activate") && player_close && (picked_up || !can_pick_up)):
		if(player_hand.get_parent().first_pick == false):
			player_hand.get_parent().first_pick = true
			Globals.first_interaction = str(object.name)
		object.action()
		print("action")






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


func respawn():
	object.sleeping = true
	object.global_position = last_pos


func _on_animation_player_animation_finished(anim_name):
	$poof_effect.visible = false
	#object.visible = true
