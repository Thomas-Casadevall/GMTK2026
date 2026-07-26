extends AudioStreamPlayer

var start_sound_has_been_played : bool = false

@onready var new_rocket_sound = $NewRocket
@onready var rocket_launch = $RocketLaunch
@onready var rocket_explode = $RocketExplode
@onready var start_sound = $StartSound
@onready var game_over = $GameOver
@onready var perfect = $Perfect
@onready var mild_perfect = $MildPerfect
@onready var bad_timing = $BadTiming
@onready var ambience_game = $AmbienceGame
@onready var ambience_menu = $AmbienceMenu

func on_new_game() -> void:
	start_sound_has_been_played = false

func play_new_rocket() -> void:
	new_rocket_sound.play()

func play_rocket_launch() -> void:
	rocket_launch.play()

func play_rocket_explode() -> void:
	rocket_explode.play()

func play_start_sound() -> void:
	if !start_sound_has_been_played:
		start_sound.play()
		start_sound_has_been_played = true

func play_game_over() -> void:
	if start_sound.playing:
		start_sound.stop()
	game_over.play()


func play_perfect() -> void:
	perfect.play()

func play_mild_perfect() -> void:
	mild_perfect.play()

func play_bad_timing() -> void:
	bad_timing.play()

func play_ambience_game() -> void:
	ambience_game.play()

func play_ambience_menu() -> void:
	ambience_menu.play()
