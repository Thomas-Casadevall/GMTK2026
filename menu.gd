extends Control

var start_launch_animation:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$animation_loop.one_shot = false
	$animation_loop.wait_time = 2
	$animation_loop.start()
	print ($AnimationPlayer.is_playing())
	$ground_pos/Path2D/PathFollow2D/Rocket.force_visible()
	$animation_loop.timeout.connect(animate)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func animate() -> void:
	print("menu loop")
	if start_launch_animation:
		$AnimationPlayer.play("rocket_launch")
		start_launch_animation = false
	else :
		$AnimationPlayer.play("RESET")
		start_launch_animation = true

func _input(event):
	if event is InputEventKey or event is InputEventMouseButton:
		if event.is_action_pressed("primary_input"):
			if $mini_wait.time_left != 0:
				return
			get_tree().change_scene_to_file("res://main_screen.tscn")
