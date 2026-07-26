extends Node2D

const tiers = [88, 40, 20, 5] # DONT FORGET TO UPDATE UI IF YOU CHANGE THIS
@onready var sfx_manager = SfxManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	 
	$Panel/CenterContainer/VBox/Label.text = GlobalVariables.game_over_reason
	$mini_wait.start()
	$mini_wait.wait_time = 1
	$Panel/CenterContainer/VBox/launches_lbl.text = "Today you launched " + str(GlobalVariables.launch_count) + " rockets."
	$Panel/CenterContainer/VBox/perfects_lbl.text = "Of which " + str(GlobalVariables.perfect_launches_count) + " were perfect launches!"
	
	var score:float = GlobalVariables.launch_count + GlobalVariables.perfect_launches_count * 1.5
	$Panel/CenterContainer/VBox/score_lbl.text = "Your pay today is $" + str(score).pad_decimals(2) + "."
	
	
	# Tiers
	if score > tiers[0]:
		$markers/plat.visible = true
	elif score > tiers[1]:
		$markers/gold.visible = true
	elif score > tiers[2]:
		$markers/silver.visible = true
	elif score > tiers[3]:
		$markers/bronze.visible = true
	#else:
		#$Panel/CenterContainer/VBox/you_suck.visible = true
		#$markers/you.visible = true
	sfx_manager.play_game_over()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event):
	if event is InputEventKey or event is InputEventMouseButton:
		if event.is_action_pressed("primary_input"):
			print ($mini_wait.time_left)
			if $mini_wait.time_left != 0:
				return
			sfx_manager.on_new_game()
			get_tree().change_scene_to_file("res://main_screen.tscn")
