extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var head = $head
@onready var head_cam = $head/Camera3D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var look_rot: Vector2
var can_rot = true
var is_idle = false
var first_pick = false
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _physics_process(delta):
	
		
		#print(collision.name)
	# Add the gravity.
	
	# Handle jump.
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		is_idle = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		is_idle = true

	move_and_slide()
	#head.rotation_degrees.x = look_rot.x
	rotation_degrees.y = look_rot.y
	if(Input.is_action_just_pressed("push")):
		$push/CollisionShape3D.disabled = false
		$AnimationPlayer.play("push")
		await get_tree().create_timer(0.5).timeout
		
		$push/CollisionShape3D.disabled = true
	
func _input(event):
	if event is InputEventMouseMotion && can_rot:
		look_rot.y -= (event.relative.x*0.25)
		look_rot.x -= (event.relative.y*0.25)
		look_rot.x = clamp(look_rot.x, -80, 90)
		is_idle = false
	else:
		is_idle = true


func _on_crying_lock_rotation(lock):
	can_rot = lock
