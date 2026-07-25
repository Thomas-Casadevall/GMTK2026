extends Node2D

#var screens: Array[Node2D]

var TOTAL_TIME: float = 5;

var fenetre: float = 0.1;

var list_space_scenes = []

var space_screen_scene = preload("res://space_screen.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_screen()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func add_screen() -> void:
	var scene = space_screen_scene.instantiate()
	scene.rocket_exploded.connect(on_rocket_crashed)
	list_space_scenes.append(scene)
	scene.init_time(TOTAL_TIME, fenetre)
	add_child(scene)
	$beat.timeout.connect(scene.sync)
	print("on ajoute une scene")

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
