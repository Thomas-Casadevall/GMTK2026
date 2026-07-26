extends Node

var list_space_scenes = []

var MAX_SPACE_PANELS = 4

var MAINCLOCK_TIME:float = 1.0

var main_screen:Node2D

enum PRESSED {
	before_beat,
	perfect_before,
	perfect_after,
	after_beat,
	off
}

var rocket_parts_mixed:bool = false

var launch_count: int = 0;

var game_over_reason: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
