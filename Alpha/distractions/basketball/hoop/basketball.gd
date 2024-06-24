extends Node3D

var score_num = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_net_area_area_entered(area):
	score_num+= 1
	$score.text = str(score_num)
