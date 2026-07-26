extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CenterContainer/Label.text = GlobalVariables.game_over_reason
	$mini_wait.start()
	$mini_wait.wait_time = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _unhandled_input(event):
	if event is InputEventKey:
		print ($mini_wait.time_left)
		if $mini_wait.time_left != 0:
			return
		get_tree().change_scene_to_file("res://main_screen.tscn")
