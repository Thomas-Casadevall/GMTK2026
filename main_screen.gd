extends Node2D

var TOTAL_TIME: float = 5;
var fenetre: float = 0.2;
var resize_factor = 1

var start_sound = preload("res://entities/assets/audio/sfx/ui_mainmenu_start.wav")
var game_over_sound = preload("res://entities/assets/audio/sfx/ui_mainmenu_exit.wav")

var perfect_timing_sound = preload("res://entities/assets/audio/sfx/timingfeedback_perfect_v1.wav")
var mild_perfect_timing_sound = preload("res://entities/assets/audio/sfx/timingfeedback_good_v1.wav")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("READY")
	GlobalSignalHandler.rocket_launched.connect(on_rocket_launched)	
	GlobalWindowsHandler.available_panels.append(self)
	$SFXPlayer.stream = start_sound
	$SFXPlayer.play()
	
	add_screen()

func add_screen():
	var rocket_scene = GlobalWindowsHandler.add_screen()
	if rocket_scene == null:
		return  # No sceen created :(
	print("rocket_scene.init_time")
	rocket_scene.init_time(TOTAL_TIME, 1, fenetre, 4, $beat)
	#$beat.timeout.connect(rocket_scene.sync)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE:
			var at_least_one_launched:bool = false;
			# si c'est dans la fenetre on balance au scenes filles
			var timing : GlobalVariables.PRESSED = GlobalVariables.PRESSED.off
			if $beat.time_left < fenetre :
				timing = GlobalVariables.PRESSED.before_beat
			elif $beat.time_left > 1 - fenetre:
				timing = GlobalVariables.PRESSED.after_beat
			elif $beat.time_left == 0 :
				timing = GlobalVariables.PRESSED.perfect
			# en dehors de la fenetre
			else :
				$SFXPlayer.stream = game_over_sound
				$SFXPlayer.play()
				
				game_over("out of rythm")
				return
			for scene in GlobalVariables.list_space_scenes:
				if scene.space_key_pressed(timing):
					at_least_one_launched = true
					if timing == GlobalVariables.PRESSED.perfect:
						$SFXPlayer.stream = perfect_timing_sound
						$SFXPlayer.play()
					elif timing == GlobalVariables.PRESSED.before_beat or timing == GlobalVariables.PRESSED.after_beat :
						$SFXPlayer.stream = mild_perfect_timing_sound
						$SFXPlayer.play()
						
			if (!at_least_one_launched):
				game_over("no rocket to launch !")

func on_rocket_launched():
	print("LAUNCHED")
	await get_tree().create_timer(0.5).timeout
	GlobalVariables.launch_count +=1;
	if GlobalVariables.launch_count %2 :
		add_screen()
	if GlobalVariables.launch_count > 3 :
		GlobalVariables.rocket_parts_mixed = true
		

func on_rocket_crashed():
	game_over("no rocket to launch !")

func game_over(cause):
	GlobalVariables.game_over_reason = cause
	print ("GAME OVER : ", cause)
	get_tree().change_scene_to_file("res://game_over.tscn")

func _on_beat_timeout() -> void:
	$AnimationPlayer.play("beat_visualization")
