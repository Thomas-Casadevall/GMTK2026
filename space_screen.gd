extends Node2D

var TOTAL_TIME: float = 6;

signal rocket_launched

var is_launched = false
var is_crashed = true

var is_synced = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$COUNTDOWN.wait_time = TOTAL_TIME


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var time = $COUNTDOWN.time_left
	var decimals = 2 if time <= 4 else 0
	$Countdown_container/Countdown_label.text = str(time).pad_decimals(decimals)


func sync() -> void:
	if is_synced:
		return
	$COUNTDOWN.start()
	is_synced = true


func space_key_pressed():
	print("scene received space")
	if $COUNTDOWN.time_left < 1:
		$Countdown_container/Countdown_label.text = "Launched !"
		is_launched = true
		GlobalSignalHandler.emit_signal("rocket_launched")
		

func _on_countdown_timeout() -> void:
	print("Game over")
	is_crashed = true
	$Countdown_container/Countdown_label.text = "Crashed !"
