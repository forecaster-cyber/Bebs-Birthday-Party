extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Firebase.Auth.login_succeeded.connect(on_login_succeeded)
	Firebase.Auth.login_failed.connect(on_login_failed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	Globals.id = $TextEdit.text
	var email = "forecaster1310@gmail.com"
	var password = "Serg131021"
	Firebase.Auth.login_with_email_and_password(email, password)
	
func on_login_succeeded(auth):
	get_tree().change_scene_to_file("res://tutorial/tut.tscn")
func on_login_failed(error_code, message):
	print(error_code)
	print(message)

