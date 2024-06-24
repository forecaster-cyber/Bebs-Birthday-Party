extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func action():
	var angle = self.rotation.y
	#print(angle)
	apply_central_impulse(Vector3(0,10,-15))
	#apply_force(Vector3(0,0,-200))
	#apply_central_force(Vector3(0,0,-200))
