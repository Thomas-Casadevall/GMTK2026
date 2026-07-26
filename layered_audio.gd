class_name CountdownPlayer
extends AudioStreamPlayer

@export var rocket_times : Array[float]

var volume_down : float = -60.0
var volume_up : float = 0.0

@onready var countdown_player : AudioStreamSynchronized = self.stream

func _ready() -> void: #set the countdown streams to inaudible
	countdown_player.set_sync_stream_volume(0, volume_down)
	countdown_player.set_sync_stream_volume(1, volume_down)
	countdown_player.set_sync_stream_volume(2, volume_down)
	countdown_player.set_sync_stream_volume(3, volume_down)
	countdown_player.set_sync_stream_volume(4, volume_down)
	countdown_player.set_sync_stream_volume(5, volume_down)

func start_rocket_countdown(rocket_num : int) -> void:
	var countdown_max : int = 8
	var countdown_num : int = countdown_max
	var stream_timing : float = rocket_times[rocket_num]
	countdown_player.set_sync_stream_volume(rocket_num, volume_up) #brings the current rocket music track up
	#here we need to have the rocket's countdown number match the timing of the rhythm for the rocket_times - so if rhythm_1 is playing, the numbers should go down every 1.5 seconds

func on_rocket_launch(rocket_num : int) -> void:
	countdown_player.set_sync_stream_volume(rocket_num, volume_down) #reset the stream to silent
