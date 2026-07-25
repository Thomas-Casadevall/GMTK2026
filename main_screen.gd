extends Node2D

var TOTAL_TIME: float = 5;
var fenetre: float = 0.1;
var resize_factor = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignalHandler.rocket_launched.connect(on_rocket_launched)	
	GlobalWindowsHandler.available_panels.append(self)
	add_screen()

func add_screen():
	var rocket_scene = GlobalWindowsHandler.add_screen()
	if rocket_scene == null:
		return  # No sceen created :(
	
	rocket_scene.init_time(TOTAL_TIME, fenetre)
	$beat.timeout.connect(rocket_scene.sync)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE:
			var at_least_one_launched:bool = false;
			# si c'est dans la fenetre on balance au scenes filles
			if $beat.time_left < fenetre or $beat.time_left > 1 - fenetre:
				for scene in GlobalVariables.list_space_scenes:
					if scene.space_key_pressed():
						at_least_one_launched = true
				if (!at_least_one_launched):
					game_over("no rocket to launch !")
			else :
				game_over("out of rythm")

func on_rocket_launched():
	print("LAUNCHED")
	await get_tree().create_timer(0.5).timeout
	add_screen()

func on_rocket_crashed():
	game_over("no rocket to launch !")

func game_over(cause):
	print ("GAME OVER : ", cause)

func _on_beat_timeout() -> void:
	$AnimationPlayer.play("beat_visualization")
