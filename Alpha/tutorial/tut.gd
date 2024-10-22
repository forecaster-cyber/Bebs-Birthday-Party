extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Globals.isTalking):
		$exit.visible = true
		$instruction/inst_text.text = "על מנת להחזיק את המתנה, לחצו E. על מנת להניח אותה, לחצו שוב פעם E."
		$Sprite3D.show()
	else:
		$exit.visible = false


func _on_door_body_entered(body):
	if(body.name == "player"):
		get_tree().change_scene_to_file("res://main.tscn")


func _on_area_3d_body_entered(body):
	if(body.name == "Gift"):
		$AnimationPlayer.play("move_npc")
		$enviorment/door.monitorable = true
		$enviorment/door.monitoring = true


func _on_texture_button_pressed():
	$player.position = Vector3($player.position.x+ 0,$player.position.y+ 0,$player.position.z+ -1)
