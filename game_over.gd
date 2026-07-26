extends Node2D

@onready var sfx_manager = SfxManager

var game_over_sound = preload("res://entities/assets/audio/sfx/ui_mainmenu_exit.wav")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CenterContainer/Label.text = GlobalVariables.game_over_reason
	$mini_wait.start()
	$mini_wait.wait_time = 1
	
	
	$SFXPlayer.stream = game_over_sound
	$SFXPlayer.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _unhandled_input(event):
	if event is InputEventKey:
		print ($mini_wait.time_left)
		if $mini_wait.time_left != 0:
			return
		sfx_manager.on_new_game()
		get_tree().change_scene_to_file("res://main_screen.tscn")
