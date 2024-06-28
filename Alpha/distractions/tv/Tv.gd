extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.sleeping = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func action():
	print("helloooo")
	$SubViewport/VideoStreamPlayer.play()


func _on_area_3d_area_entered(area):
	if(area.name == "looking_at"):
		$SubViewport/VideoStreamPlayer.volume_db = 15


func _on_area_3d_area_exited(area):
	if(area.name == "looking_at"):
		$SubViewport/VideoStreamPlayer.volume_db = -30
