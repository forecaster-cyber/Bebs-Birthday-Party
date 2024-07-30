extends RigidBody3D

var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func action():
	var random = rng.randf_range(-1,1)
	$AnimationPlayer.play("balloon")
	$AudioStreamPlayer.play()
	apply_central_impulse(Vector3(0,2,random))
