extends Node2D
signal rocket_exploded

var synchronized: bool = false;
var crashed: bool = false;

var beat_timer = preload("res://beat_timer.tscn")


var b_countdown
var b_restart
var b_construction

# etat de la scene
enum STATE {
	wait_init,
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

@onready var rocket_ref = $ground_pos/Path2D/PathFollow2D/Rocket

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	b_countdown = beat_timer.instantiate()
	b_restart = beat_timer.instantiate()
	b_construction = beat_timer.instantiate()
	#$ground_pos/Path2D/PathFollow2D.rotation = -PI/2  # Very important, otherwise the anmiation sets a dumb rotation value
	var background = backgrounds[randi() % backgrounds.size()]
	$background.texture = background
	$Countdown_container/Countdown_label.text = ""
	
	# timer signal plug
	#b_construction.timeout.connect(constructed)
	b_restart.timeout.connect(start_construction)
	$timeout_fenetre.timeout.connect(_on_timeout_fenetre_timeout)
	b_countdown.timeout.connect(_on_countdown_timeout)
	rocket_ref.construction_done.connect(constructed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if current_state == STATE.countdown:
		var time = b_countdown.time_left
		#$Countdown_container/Countdown_label.text = str(ceil(time)).pad_decimals(0)
		$Countdown_container/Countdown_label.text = str(time)


func init_time(time_countdown :float, time_construction :float, time_fenetre :float, time_restart:float, beat:Timer) -> void:
	if current_state != STATE.wait_init:
		return
	b_countdown.wait_time = time_countdown
	beat.timeout.connect(b_countdown.process_beat)
	b_construction.wait_time = time_construction
	beat.timeout.connect(b_construction.process_beat)
	$timeout_fenetre.wait_time = time_fenetre
	b_restart.wait_time = time_restart
	beat.timeout.connect(b_restart.process_beat)
	beat.timeout.connect(sync)
	# Next step
	start_construction()

func constructed() -> void:
	$Countdown_container/Countdown_label.text = str(b_countdown.wait_time -1)
	b_countdown.start()
	$ground_pos/Path2D/PathFollow2D/Rocket.start_smoke()
	rocket_ref.construction_done.connect(constructed)


func sync() -> void:
	match current_state:
		STATE.done:
			start_construction()
		STATE.construction:
			rocket_ref.construct_step()
	current_state = STATE.countdown

func space_key_pressed() -> bool:
	print("scene received space")
	if current_state == STATE.countdown:
		print(b_countdown.time_left)
		if b_countdown.time_left < 0.5:
			print("rocket envoyee")
			$Countdown_container/Countdown_label.text = "Launched!"
			GlobalSignalHandler.emit_signal("rocket_launched")
			$AnimationPlayer.play("rocket_launch")
			$background.shake()
			# next state
			is_done()
		return true
	return false

func is_done() -> void:
	current_state = STATE.done
	b_restart.start()

func explode() -> void:
	rocket_exploded.emit()
	$Countdown_container/Countdown_label.text = "Crashed!"
	# State change
	is_done()

func start_construction() -> void:
	$Countdown_container/Countdown_label.text = "Construction..."
	current_state = STATE.construction
	rocket_ref.reset()
	b_construction.start()
	# TODO construction animation

func _on_countdown_timeout() -> void:
	print("current_state : ", current_state)
	if current_state == STATE.countdown:
		print("t'as encore la fenetre !")
		$timeout_fenetre.start()

func _on_timeout_fenetre_timeout() -> void:
	print("_on_timeout_fenetre_timeout")
	if current_state == STATE.countdown:
		explode()
