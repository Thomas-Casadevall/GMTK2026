extends Node2D

#var screens: Array[Node2D]

var main_timer:Timer;

var list_space_scenes = []

var space_screen_scene = preload("res://space_screen.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_timer = get_node("main_timer")
	add_screen()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func add_screen() -> void:
	var scene = space_screen_scene.instantiate()
	list_space_scenes.append(scene)
	add_child(scene)
	main_timer.timeout.connect(scene.countdown)
	print("on ajoute une scene")
	
	pass


func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE:
			for scene in list_space_scenes:
				scene.space_key_pressed()
			
