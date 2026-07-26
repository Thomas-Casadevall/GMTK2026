extends AudioStreamPlayer

@onready var new_rocket_sound = $NewRocket
@onready var rocket_launch = $RocketLaunch
@onready var rocket_explode = $RocketExplode
@onready var start_sound = $StartSound
@onready var game_over = $GameOver
@onready var perfect = $Perfect
@onready var mild_perfect = $MildPerfect

func play_new_rocket() -> void:
	new_rocket_sound.play()

func play_rocket_launch() -> void:
	rocket_launch.play()

func play_rocket_explode() -> void:
	rocket_explode.play()

func play_start_sound() -> void:
	start_sound.play()

func play_game_over() -> void:
	game_over.play()

func play_perfect() -> void:
	perfect.play()

func play_mild_perfect() -> void:
	mild_perfect.play()
