extends Node

var space_screen_scene = preload("res://space_screen.tscn")

var available_panels = []
var taken_panels = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func add_screen():
	print("add_screen")
	
	# If there is no more panel available, create some and put old scene in 
	if len(available_panels) == 0:
		print("besoin de rajouter des panneaux")
		# The goal is to find the scene with the least scene_resize_factor
		var scene_to_split = GlobalVariables.list_space_scenes[0]
		print("  Found a scene ",scene_to_split.name," (",scene_to_split.scene_resize_factor,")")
		for scene in GlobalVariables.list_space_scenes:
			print("  Compared to a scene ",scene.name," (",scene.scene_resize_factor,")")
			if scene.scene_resize_factor < scene_to_split.scene_resize_factor:
				scene_to_split = scene
		var factor = scene_to_split.scene_resize_factor
		
		# On récupère le panel de la scene à split
		var panel_scene_to_split = scene_to_split.get_parent()
		# On lui assigne une nouvelle grille en 2x2
		panel_scene_to_split.add_child(create_four_panels(factor))
		# On récupère un des nouveau panneau dispo
		var new_panel_to_use = available_panels.pop_front()
		# On met l'ancienne scene à split dans ce panel
		scene_to_split.reparent(new_panel_to_use)
		# L'ancienne scene se fait réduire
		scene_to_split.scene_resize_factor +=1
		# On considère ce pannel comme pris
		taken_panels.append(new_panel_to_use)
		
	
	# Maintenant qu'il y a des panneaux dispos
	var panel_to_use = available_panels.pop_front()
	var new_scene = space_screen_scene.instantiate()
	var factor_of_new_scene
	if panel_to_use.has_meta("resize_factor"):
		factor_of_new_scene =  panel_to_use.get_meta("resize_factor")
	else:
		factor_of_new_scene = panel_to_use.resize_factor
	if factor_of_new_scene < 3:
		print("New factor ",factor_of_new_scene)
		new_scene.scene_resize_factor = factor_of_new_scene
		GlobalVariables.list_space_scenes.append(new_scene)
		print("Will use panel ",panel_to_use.name)
		panel_to_use.add_child(new_scene)
		print("Added scene ", new_scene.name)
		taken_panels.append(panel_to_use)
		
		return new_scene

func create_four_panels(factor):
	print("  Creating 4 new panels with factor ", factor)
	print("  Side size : ", 800/(factor*2))
	var vbox = VBoxContainer.new()
	# Il faut lui mettre la taille de sa node
	vbox.size = Vector2(800/factor,800/factor)
	
	var hbox1 = HBoxContainer.new()
	hbox1.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(hbox1)
	
	var control1 = Control.new()
	control1.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	control1.set_meta("resize_factor", factor + 1)
	hbox1.add_child(control1)
	available_panels.append(control1)
	var control2 = Control.new()
	control2.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	control2.set_meta("resize_factor", factor + 1)
	hbox1.add_child(control2)
	available_panels.append(control2)
	
	var hbox2 = HBoxContainer.new()
	vbox.add_child(hbox2)
	hbox2.size_flags_vertical = 3
	
	var control3 = Control.new()
	control3.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	control3.set_meta("resize_factor", factor + 1)
	hbox2.add_child(control3)
	available_panels.append(control3)
	var control4 = Control.new()
	control4.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	control4.set_meta("resize_factor", factor + 1)
	hbox2.add_child(control4)
	available_panels.append(control4)
	
	print(vbox.name, " created :")
	print(" - ", control1.name)
	print(" - ", control2.name)
	print(" - ", control3.name)
	print(" - ", control4.name)
	
	return vbox
