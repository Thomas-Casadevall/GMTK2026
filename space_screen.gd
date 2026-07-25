extends Node2D

var TOTAL_TIME: float = 6;
var FENETRE: float = 0.1;
var init_done: bool = false;
var crashed: bool = false;

signal rocket_launched
signal rocket_exploded

var is_launched = false
var is_crashed = true

var is_synced = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$COUNTDOWN.wait_time = TOTAL_TIME
	$Countdown_container/Countdown_label.text = str(TOTAL_TIME)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var time = $COUNTDOWN.time_left
	$Countdown_container/Countdown_label.text = str(time).pad_decimals(0)

func init_time(_time :int, _fenetre :int) -> void:
	TOTAL_TIME = _time
	FENETRE = _fenetre
	$COUNTDOWN.wait_time = TOTAL_TIME
	$Timeout_fenetre.wait_time = _fenetre
	$Countdown_container/Countdown_label.text = str(TOTAL_TIME)
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
		$ground_pos/Sprite_fusee.launch()
		return true
	return false


func _on_countdown_timeout() -> void:
	$Timeout_fenetre.start()


func _on_timeout_fenetre_timeout() -> void:

	rocket_exploded.emit()
	print("Game over fenetre")
	is_crashed = true
	$Countdown_container/Countdown_label.text = "Crashed !"
	
