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

var skybox_textures := [
	preload("res://entities/assets/images/bg/SKY_var1.png"),
	preload("res://entities/assets/images/bg/SKY_var2.png"),
	preload("res://entities/assets/images/bg/SKY_var3.png")
]

var cloud_textures := [
	preload("res://entities/assets/images/bg/CLOUDS_var1.png"),
	preload("res://entities/assets/images/bg/CLOUDS_var2.png"),
	preload("res://entities/assets/images/bg/CLOUDS_var3.png")
]

var ground_textures := [
	preload("res://entities/assets/images/bg/GROUND_var1.png"),
	preload("res://entities/assets/images/bg/GROUND_var2.png"),
	preload("res://entities/assets/images/bg/GROUND_var3.png")
]

var hill_textures := [
	preload("res://entities/assets/images/bg/HILL_var1.png"),
	preload("res://entities/assets/images/bg/HILL_var2.png"),
	preload("res://entities/assets/images/bg/HILL_var3.png")
]

@onready var rocket_ref = $ground_pos/Path2D/PathFollow2D/Rocket

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$background/skybox.texture = skybox_textures.pick_random()
	$background/clouds.texture = cloud_textures.pick_random()
	$background/ground.texture = ground_textures.pick_random()
	$background/mountains.visible = randi()%2
	$background/hill.texture = hill_textures.pick_random()
	
	$Countdown_container/Countdown_label.text = ""
	
	# timer signal plug
	rocket_ref.construction_done.connect(constructed)
	$Restart.timeout.connect(wait_to_sync)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if current_state != STATE.countdown:
		return
	var time = $COUNTDOWN.time_left
	$Countdown_container/Countdown_label.text = str(ceil(time)).pad_decimals(0)

func init_time(time_countdown: float, time_construction: float, time_fenetre: float, time_restart: float) -> void:
	if current_state != STATE.wait_init:
		return
	$COUNTDOWN.wait_time = time_countdown
	$Construction.wait_time = time_construction
	$Timeout_fenetre.wait_time = time_fenetre
	$Restart.wait_time = time_restart
	print("init done !")
	# Next state
	wait_to_sync()

# just set the wait to sync status
func wait_to_sync() -> void:
	current_state = STATE.wait_sync
	rocket_ref.reset()

func sync() -> void:
	match current_state:
		STATE.wait_sync:
			start_construction()
		STATE.construction:
			rocket_ref.construct_step()

func constructed() -> void:
	print("construction finished !")
	$Countdown_container/Countdown_label.text = str($COUNTDOWN.wait_time -1)
	$COUNTDOWN.start()
	rocket_ref.start_smoke()
	current_state = STATE.countdown

func space_key_pressed() -> bool:
	print("scene received space")
	if current_state == STATE.countdown:
		print($COUNTDOWN.time_left)
		if $COUNTDOWN.time_left < 0.5:
			print("rocket envoyee")
			$Countdown_container/Countdown_label.text = "Launched!"
			GlobalSignalHandler.emit_signal("rocket_launched")
			$AnimationPlayer.play("rocket_launch")
			$background/skybox.shake()
			$background/clouds.shake()
			$background/ground.shake()
			$background/mountains.shake()
			$background/hill.shake()
			rocket_ref.start_fire()
			# next state
			is_done()
		return true
	return false

func is_done() -> void:
	current_state = STATE.done
	$Restart.start()

func explode() -> void:
	rocket_exploded.emit()
	$Countdown_container/Countdown_label.text = "Crashed!"
	# State change
	is_done()

func start_construction() -> void:
	$Countdown_container/Countdown_label.text = "Construction..."
	current_state = STATE.construction

func _on_countdown_timeout() -> void:
	$Timeout_fenetre.start()

func _on_timeout_fenetre_timeout() -> void:
	if current_state == STATE.countdown:
		explode()
