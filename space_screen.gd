extends Node2D
signal rocket_exploded

var synchronized: bool = false;
var crashed: bool = false;

# etat de la scene
enum STATE {
	wait_init,
	wait_sync,
	construction,
	countdown,
	done
}

var current_state:STATE = STATE.wait_init;

var scene_resize_factor = 1

var backgrounds := [
	preload("res://entities/assets/images/bg/BG-var2.jpg"),
	preload("res://entities/assets/images/bg/BG-var3.jpg"),
	preload("res://entities/assets/images/bg/BG-var4.jpg")
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var background = backgrounds[randi() % backgrounds.size()]
	$background.texture = background
	$Countdown_container/Countdown_label.text = "Construction..."
	
	# timer signal plug
	$Construction.timeout.connect(constructed)
	$Restart.timeout.connect(start_construction)
	print("rocket ready")	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if current_state ==	STATE.countdown:
		# Updat timer
		var time = $COUNTDOWN.wait_time if $COUNTDOWN.is_stopped() else $COUNTDOWN.time_left
		$Countdown_container/Countdown_label.text = str(floor(time)).pad_decimals(0)
	return


func init_time(time_countdown :float, time_construction :float, time_fenetre :float, time_restart:float) -> void:
	if current_state == STATE.wait_init:
		$COUNTDOWN.wait_time = time_countdown
		$Construction.wait_time = time_construction
		$Timeout_fenetre.wait_time = time_fenetre
		$Restart.wait_time = time_restart
		print("init done !")
		# Next state
		current_state = STATE.wait_sync

func sync() -> void:
	if current_state != STATE.wait_sync:
		return
	print("sync done !")	
	start_construction()
	
func constructed() -> void:
	print("construction finished !")	
	$Countdown_container/Countdown_label.text = str($COUNTDOWN.wait_time -1)
	$COUNTDOWN.start()
	$ground_pos/Rocket/AnimatedSprite2D.play()
	current_state = STATE.countdown

func space_key_pressed() -> bool:
	print("scene received space")
	if current_state == STATE.countdown:
		print($COUNTDOWN.time_left)
		if $COUNTDOWN.time_left < 1.0:
			print("rocket envoyee")
			$Countdown_container/Countdown_label.text = "Launched !"
			GlobalSignalHandler.emit_signal("rocket_launched")
			#$ground_pos/Sprite_fusee.launch()
			$ground_pos/Rocket.launch()

			# next state
			is_done()
		return true
	return false

func is_done() -> void :
	current_state = STATE.done
	$Restart.start()

func start_construction() -> void:
	$Countdown_container/Countdown_label.text = "Construction..."
	current_state = STATE.construction
	$Construction.start()
	# TODO construction animation

func _on_countdown_timeout() -> void:
	$Timeout_fenetre.start()

func _on_timeout_fenetre_timeout() -> void:
	rocket_exploded.emit()
	print("Game over fenetre")
	
	# State change
	is_done()
	$Countdown_container/Countdown_label.text = "Crashed !"
