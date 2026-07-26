extends Node2D

signal construction_done
@onready var constrution_order := [
	$turbo,
	$cabin,
	$hat,
]
var construction_step := 0

func _ready() -> void:
	set_process(false)
	reset()

func reset() -> void:
	$AnimatedSprite2D.visible = false
	$AnimatedSprite2D.pause()
	position = Vector2.ZERO
	construction_step = 0
	constrution_order.map(func(s): s.visible = false)

func start_smoke() -> void:
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play()

func construct_step() -> void:
	constrution_order[construction_step].visible = true
	construction_step += 1
	if construction_step >= constrution_order.size():
		emit_signal("construction_done")
