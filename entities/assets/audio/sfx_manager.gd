extends AudioStreamPlayer

@onready var new_rocket_sound = $NewRocket
@onready var rocket_launch = $RocketLaunch
@onready var rocket_explode = $RocketExplode

func play_new_rocket() -> void:
	new_rocket_sound.play()

func play_rocket_launch() -> void:
	rocket_launch.play()

func play_rocket_explode() -> void:
	rocket_explode.play()
