extends Node2D

const SPEED := 800

func _ready() -> void:
	reset()

func _process(delta: float) -> void:
	position.y -= SPEED * delta
	if global_position.y <= -800:
		set_process(false)
		position = Vector2.ZERO

func launch() -> void:
	set_process(true)
	
func reset() -> void:
	set_process(false)
	position = Vector2.ZERO
