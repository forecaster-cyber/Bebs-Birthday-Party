extends Node3D

@export var player: Node3D
@export var sound_fx: AudioStreamMP3
var a = Vector2()
func _ready():
	$sound_fx.stream = sound_fx
	$sound_fx.play()
	 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player_to_enemy = (global_transform.origin - player.global_transform.origin)
	var player_forward = -player.global_transform.basis.z
	var dot_product = player_to_enemy.dot(player_forward)
	if dot_product<0:
		$sound_fx.volume_db = -30
		
	else:
		$sound_fx.volume_db = dot_product/10
	#print($sound_fx.volume_db)
	
