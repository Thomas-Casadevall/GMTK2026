class_name MusicPlayer
extends AudioStreamPlayer

@export var rocket_times : Array[float]

@onready var music_player : AudioStreamSynchronized = self.stream

func _ready() -> void:
	music_player.set_sync_stream_volume(0, 0.0) #setting the base track to 0 db, the others to silent
	music_player.set_sync_stream_volume(1, -40)
	music_player.set_sync_stream_volume(2, -40)
	music_player.set_sync_stream_volume(3, -40)
	music_player.set_sync_stream_volume(4, -40)


func start_rocket_countdown(rocket_num : int) -> void:
	var countdown_max : int = 8
	var countdown_num : int = countdown_max
	music_player.set_sync_stream_volume(rocket_num, 0) #brings the current rocket music track up
	while countdown_num > countdown_max /2: #I suspect this section should be in the individual rocket's script, not here
		# use a timer to count up to the time in rocket_times[rocket_num]
		# countdown_num goes down by 1 each time the timer hits that 
		pass
	#once the countdown_num is half of the _max, start the rocket timer countdown (on screen numbers)
	#player will press rocket launch button

func on_rocket_launch(rocket_num : int) -> void:
	music_player.set_sync_stream_volume(rocket_num, -40) #reset the stream to silent
