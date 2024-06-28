extends Node3D

@export var player: Node3D
@export var sound_fx: AudioStreamMP3
@export var bday_music: AudioStreamPlayer3D
@export var min_sound: int = -10
@export var max_sound: int = 100
var a = Vector2()
func _ready():
	$sound_fx.stream = sound_fx
	#$sound_fx.play()
	 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_to_enemy = (global_transform.origin - player.global_transform.origin)
	var player_forward = -player.global_transform.basis.z
	var dot_product = player_to_enemy.dot(player_forward)
	if dot_product<0:
		bday_music.volume_db = 0
		
	else:
		bday_music.volume_db = 1/(-dot_product)*25
	print(bday_music.volume_db)
	#print($sound_fx.volume_db)
	
