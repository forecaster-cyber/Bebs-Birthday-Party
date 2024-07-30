extends RigidBody3D

var opened = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func action():
	if(!opened):
		$AudioStreamPlayer.play()
		$AnimationPlayer.play("opening")
		await get_tree().create_timer(3.0).timeout
		$Sketchfab_Scene.set_visible(true)
		$Sketchfab_Scene2.set_visible(false)
		opened = true
	else:
		$quack.play()
