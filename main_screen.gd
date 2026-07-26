extends Node2D

var TOTAL_TIME: float = 5;
var fenetre: float = 0.2;
var perfect_fenetre: float = fenetre/3;
var resize_factor = 1

var start_sound = preload("res://entities/assets/audio/sfx/ui_mainmenu_start.wav")

var perfect_timing_sound = preload("res://entities/assets/audio/sfx/timingfeedback_perfect_v1.wav")
var mild_perfect_timing_sound = preload("res://entities/assets/audio/sfx/timingfeedback_good_v1.wav")

var unpressed_space = preload("res://entities/assets/images/bg/KEY_Space_Unpress.png")
var pressed_space = preload("res://entities/assets/images/bg/KEY_Space_Press.png")

@onready var sfx_manager = SfxManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("READY")
		
	# re init
	GlobalVariables.list_space_scenes = []
	GlobalWindowsHandler.available_panels = []
	GlobalWindowsHandler.taken_panels = []
	GlobalVariables.launch_count = 0;
	GlobalSignalHandler.rocket_launched.connect(on_rocket_launched)	
	GlobalWindowsHandler.available_panels.append(self)
	GlobalVariables.main_screen = self
	
	$SFXPlayer.stream = start_sound
	$SFXPlayer.play()
	
	add_screen()

func add_screen():
	var rocket_scene = GlobalWindowsHandler.add_screen()
	if rocket_scene == null:
		return  # No sceen created :(
	print("rocket_scene.init_time")
	rocket_scene.init_time(TOTAL_TIME, 1, fenetre, 4, $beat)
	GlobalSignalHandler.rocket_exploded.connect(on_rocket_crashed)
	sfx_manager.play_start_sound()
	#$beat.timeout.connect(rocket_scene.sync)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event):
	if event is InputEventKey:
		if $mini_wait.time_left != 0:
			return
		var best_launch = null
		if event.pressed and event.keycode == KEY_SPACE:
			$Sprite2D2.texture = pressed_space
			var at_least_one_launched:bool = false;
			# si c'est dans la fenetre on balance au scenes filles
			var timing : GlobalVariables.PRESSED = GlobalVariables.PRESSED.off
			var left_time:float = $beat.time_left;
			if left_time <= fenetre and left_time > perfect_fenetre :
				timing = GlobalVariables.PRESSED.before_beat
			elif left_time <= fenetre and left_time <= perfect_fenetre :
				timing = GlobalVariables.PRESSED.perfect_before
			elif left_time >= 1 - fenetre and left_time >= 1- perfect_fenetre:
				timing = GlobalVariables.PRESSED.perfect_after
			elif left_time >= 1 - fenetre and left_time < 1- perfect_fenetre:
				timing = GlobalVariables.PRESSED.after_beat
			elif left_time == 0 :
				timing = GlobalVariables.PRESSED.perfect_after
			# en dehors de la fenetre
			else :
				sfx_manager.play_game_over()
				
				game_over("out of rythm")
				return
			for scene in GlobalVariables.list_space_scenes:
				if scene.space_key_pressed(timing):
					at_least_one_launched = true
					if timing == GlobalVariables.PRESSED.perfect_before or timing == GlobalVariables.PRESSED.perfect_after:
						best_launch = GlobalVariables.PRESSED.perfect_before
						print("PERFECT")
						scene.perfect_animation()
						
					# if there is no perfect launch timing, set the state to timing
					# (GlobalVariables.PRESSED.after_beat or GlobalVariables.PRESSED.before_beat)
					elif timing == GlobalVariables.PRESSED.before_beat:
						if best_launch != GlobalVariables.PRESSED.perfect_before and best_launch != GlobalVariables.PRESSED.perfect_after:
							best_launch = timing
						scene.blink_before_animation()
						print("TOO EARLY")
					elif timing == GlobalVariables.PRESSED.after_beat:
						if best_launch != GlobalVariables.PRESSED.perfect_before and best_launch != GlobalVariables.PRESSED.perfect_after:
							best_launch = timing
						best_launch = timing
						scene.blink_after_animation()
						print("TOO LATE")
					else:
						print("TOO WHAT ??")
						print(timing)
				
			if (!at_least_one_launched):
				game_over("no rocket to launch !")
			else:
				if best_launch == GlobalVariables.PRESSED.before_beat or best_launch == GlobalVariables.PRESSED.perfect_after:
					sfx_manager.play_perfect()
				else:
					sfx_manager.play_mild_perfect()
					
					
				
		elif event.is_released() and event.keycode == KEY_SPACE:
			$Sprite2D2.texture = unpressed_space

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
