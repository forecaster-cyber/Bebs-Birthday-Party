extends Node3D

@export var player: Node3D
@export var sound_fx: AudioStreamMP3
@export var bday_music: AudioStreamPlayer3D
@export var min_sound: int = -10
@export var max_sound: int = -10
var dot = 0
@export var others_dot: Node3D
var dot_product
var a = Vector2()
var looking_at_me = false
func _ready():
	$sound_fx.stream = sound_fx
	#$sound_fx.play()
	 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_to_enemy = (global_transform.origin - player.global_transform.origin)
	var player_forward = -player.global_transform.basis.z
	dot_product = player_to_enemy.dot(player_forward)
	dot = dot_product
	if dot_product<0 && others_dot.dot < 0:
		bday_music.volume_db = (-dot_product)
		
		
	elif((dot_product> others_dot.dot) && (dot_product> 0)):
		bday_music.volume_db = 1/(-dot_product)*25
		print("looking at me! " + str(get_parent().name) +"  fff   " + str(dot_product))
		looking_at_me = true
	else:
		looking_at_me = false
	if(looking_at_me):
		print(str(get_parent().name))
	print(bday_music.volume_db)
	print("the dot product is: " + str(dot_product))
	
	#print($sound_fx.volume_db)
	
