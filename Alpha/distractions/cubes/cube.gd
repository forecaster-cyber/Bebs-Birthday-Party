extends RigidBody3D

@export var number = 0
@export var color: Color
# Called when the node enters the scene tree for the first time.
func _ready():
	var material = $cube.get_active_material(0)
	material.albedo_color = Color(color)
	$text_print.text = str(number)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func action():
	apply_central_force(Vector3(0,300,-30))
