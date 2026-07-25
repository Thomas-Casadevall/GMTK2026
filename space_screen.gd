extends Node2D

var init_done: bool = false;
var crashed: bool = false;

signal rocket_launched
signal rocket_exploded

var is_launched = false
var is_crashed = true

var is_synced = false

var backgrounds := [
	preload("res://entities/assets/images/bg/BG-var2.jpg"),
	preload("res://entities/assets/images/bg/BG-var3.jpg"),
	preload("res://entities/assets/images/bg/BG-var4.jpg")
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var background = backgrounds[randi() % backgrounds.size()]
	$background.texture = background

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var time = $COUNTDOWN.wait_time if $COUNTDOWN.is_stopped() else $COUNTDOWN.time_left
	$Countdown_container/Countdown_label.text = str(floor(time)).pad_decimals(0)

func init_time(time :int, fenetre :int) -> void:
	$COUNTDOWN.wait_time = time
	$Timeout_fenetre.wait_time = fenetre
	$Countdown_container/Countdown_label.text = str(time)
	init_done = true;

func sync() -> void:
	if is_synced or !init_done:
		return
	$COUNTDOWN.start()
	$ground_pos/Rocket/AnimatedSprite2D.play()
	is_synced = true


func space_key_pressed() -> bool:
	print("scene received space")
	print($COUNTDOWN.time_left)
	if $COUNTDOWN.time_left < 1.0:
		print("rocket envoyee")
		$Countdown_container/Countdown_label.text = "Launched !"
		is_launched = true
		GlobalSignalHandler.emit_signal("rocket_launched")
		#$ground_pos/Sprite_fusee.launch()
		$ground_pos/Rocket.launch()
		return true
	return false


func _on_countdown_timeout() -> void:
	$Timeout_fenetre.start()


func _on_timeout_fenetre_timeout() -> void:
	rocket_exploded.emit()
	print("Game over fenetre")
	is_crashed = true
	$Countdown_container/Countdown_label.text = "Crashed !"
	
