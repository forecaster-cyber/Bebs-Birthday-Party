extends RigidBody3D

@export var bday_music: AudioStreamPlayer3D
var playing = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func action():
	print("ssssss")
	if(playing):
		bday_music.stop() 
		playing = false
		$AnimationPlayer.stop()
	else:
		bday_music.play()
		playing = true
		$AnimationPlayer.play("playing")
