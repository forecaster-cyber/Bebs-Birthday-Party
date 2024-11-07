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
var red = 1.0
var green = 1.0
var blue = 1.0

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass
	
func _physics_process(delta):
	

	# Handle rotation based on left/right arrow keys.
	if Input.is_action_pressed("ui_left"):
		rotation_degrees.y += SPEED * delta * 10 # Adjust turn speed as needed
	elif Input.is_action_pressed("ui_right"):
		rotation_degrees.y -= SPEED * delta * 10

	# Forward/backward movement with up/down arrow keys.
	var forward_direction = -transform.basis.z.normalized()
	if Input.is_action_pressed("ui_up"):
		velocity.x = forward_direction.x * SPEED
		velocity.z = forward_direction.z * SPEED
		is_idle = false
	elif Input.is_action_pressed("ui_down"):
		velocity.x = -forward_direction.x * SPEED
		velocity.z = -forward_direction.z * SPEED
		is_idle = false
	else:
		# Stop immediately when no movement keys are pressed
		velocity.x = 0
		velocity.z = 0
		is_idle = true
	
	# Move and slide with the current velocity.
	move_and_slide()

	if(Input.is_action_just_pressed("push")):
		$push/CollisionShape3D.disabled = false
		$AnimationPlayer.play("push")
		await get_tree().create_timer(0.5).timeout
		$push/CollisionShape3D.disabled = true
		print("DATA!!!!!: " + str(Globals.logs))
		print("LEGIT: " + str(Globals.id))
	
func _input(event):
	if event is InputEventMouseMotion and can_rot:
		look_rot.y -= (event.relative.x * 0.25)
		look_rot.x -= (event.relative.y * 0.25)
		look_rot.x = clamp(look_rot.x, -80, 90)
		is_idle = false
	else:
		is_idle = true

func _on_crying_lock_rotation(lock):
	can_rot = lock

func _on_robot_lock_rotation(lock):
	can_rot = lock 

func _on_npc_lock_rotation(lock):
	can_rot = lock 
