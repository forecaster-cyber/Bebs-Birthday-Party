extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print("the pos fffis: " + str($RayCast3D.get_collision_point()))

func action():
	var mark = load("res://distractions/water gun/mark.tscn")
	var instance = mark.instantiate()
	if ($RayCast3D.get_collider() == null):
		pass
	else:
		$RayCast3D.get_collider().add_child(instance)
		instance.global_position = $RayCast3D.get_collision_point()
		
	#play audio!

