extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Firebase.Auth.login_succeeded.connect(on_login_succeeded)
	Firebase.Auth.login_failed.connect(on_login_failed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if($TextEdit.text == ""):
		$Button.disabled = true
	else:
		$Button.disabled = false


func _on_button_pressed():
	Globals.id = Time.get_unix_time_from_system()
	var email = "forecaster1310@gmail.com"
	var password = "Serg131021"
	$intro.play()
	$Label.text = "שלום! ברוכים הבאים ליום ההולדת של באב! על מנת להסתכל ימינה או שמאלה, לחצו על החיצים ימינה או שמאלה. על מנת לזוז קדימה או אחורה לחצו על החיצים למעלה או למטה! על מנת לבצע אינטראקציה עם הדברים במסיבה, לחצו על E!"
	Globals.age = int($TextEdit.text)
	Globals.gender = $OptionButton.get_selected_id()
	print(Globals.gender)
	await get_tree().create_timer($intro.stream.get_length()).timeout
	Firebase.Auth.login_with_email_and_password(email, password)
	
	
	
func on_login_succeeded(auth):
	get_tree().change_scene_to_file("res://main.tscn")
func on_login_failed(error_code, message):
	print(error_code)
	print(message)

