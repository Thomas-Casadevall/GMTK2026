extends Node2D

#var screens: Array[Node2D]

var TOTAL_TIME: float = 5;

var fenetre: float = 0.1;
var resize_factor = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_timer = get_node("main_timer")
	GlobalWindowsHandler.available_panels.append(self)
	new_rocket()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func new_rocket() -> void:
	var first_rocket_scene = GlobalWindowsHandler.add_screen()
	
	GlobalSignalHandler.connect("rocket_launched", on_rocket_launch)
	main_timer.timeout.connect(first_rocket_scene.countdown)
	add_child(first_rocket_scene)
	GlobalWindowsHandler.taken_panels.append(self) # se déclare comme premier panel

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE:
			var at_least_one_launched:bool = false;
			# si c'est dans la fenetre on balance au scenes filles
			if $beat.time_left < fenetre or $beat.time_left > 1 - fenetre:
				for scene in list_space_scenes:
					if scene.space_key_pressed():
						at_least_one_launched = true
				if (!at_least_one_launched):
					game_over("no rocket to launch !")
			else :
				game_over("out of rythm")


func on_rocket_launch():
	print("Main receveive : rocket launched")
	
func on_rocket_crashed():
	game_over("no rocket to launch !")

func game_over(cause):
	print ("GAME OVER : ", cause)


func _on_beat_timeout() -> void:
	$AnimationPlayer.play("beat_visualization")
