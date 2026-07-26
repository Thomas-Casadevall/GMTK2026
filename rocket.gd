extends Node2D

const SPEED := 800

func _ready() -> void:
	set_process(false)
	reset()

func reset() -> void:
	$AnimatedSprite2D.visible = false
	$AnimatedSprite2D.pause()
	position = Vector2.ZERO

func start_smoke() -> void:
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play()
