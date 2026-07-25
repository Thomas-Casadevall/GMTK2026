extends Node2D

var init_done: bool = false;
var crashed: bool = false;

signal rocket_launched
signal rocket_exploded

var is_launched = false
var is_crashed = true

var is_synced = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var time = $COUNTDOWN.time_left
	$Countdown_container/Countdown_label.text = str(floor(time))

func init_time(time :int, fenetre :int) -> void:
	$COUNTDOWN.wait_time = time
	$Timeout_fenetre.wait_time = fenetre
	$Countdown_container/Countdown_label.text = str(time)
	init_done = true;

func sync() -> void:
	if is_synced or !init_done:
		return
	$COUNTDOWN.start()
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
	
