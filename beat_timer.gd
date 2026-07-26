extends Node

signal timeout


var wait_time:int
var time_left:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func process_beat() -> void:
	if time_left > 1:
		time_left -=1
		
	elif time_left == 1:
		time_left -=1
		timeout.emit()


func start() -> void:
	time_left = wait_time
