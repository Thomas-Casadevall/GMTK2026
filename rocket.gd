extends Node2D

signal construction_done
@onready var constrution_order := [
	$turbo,
	$cabin,
	$hat,
]

var hat_textures = [
	preload("res://entities/assets/images/rocket/ROCKET_Hat.png"),
	preload("res://entities/assets/images/rocket/ROCKET_Hat-var2.png"),
	preload("res://entities/assets/images/rocket/ROCKET_Hat-var3.png"),
	preload("res://entities/assets/images/rocket/ROCKET_Hat-var4.png")
]

var cabin_textures = [
	preload("res://entities/assets/images/rocket/ROCKET_Cabin.png"),
	preload("res://entities/assets/images/rocket/ROCKET_Cabin-var2.png"),
	preload("res://entities/assets/images/rocket/ROCKET_Cabin-var3.png"),
	preload("res://entities/assets/images/rocket/ROCKET_Cabin-var4.png"),
]

var turbo_textures = [
	preload("res://entities/assets/images/rocket/ROCKET_Turbo.png"),
	preload("res://entities/assets/images/rocket/ROCKET_Turbo-var2.png"),
	preload("res://entities/assets/images/rocket/ROCKET_Turbo-var3.png"),
	preload("res://entities/assets/images/rocket/ROCKET_Turbo-var4.png"),
]

var construction_step := 0

func _ready() -> void:
	$hat.texture = hat_textures.pick_random()
	$cabin.texture = cabin_textures.pick_random()
	$turbo.texture = turbo_textures.pick_random()
	set_process(false)
	reset()

func reset() -> void:
	$AnimatedSprite2D.visible = false
	$AnimatedSprite2D.pause()
	position = Vector2.ZERO
	construction_step = 0
	constrution_order.map(func(s): s.visible = false)

func start_smoke() -> void:
	$AnimatedSprite2D.animation = "smoke"
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play()

func start_fire() -> void:
	$AnimatedSprite2D.animation = "fire"
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play()
	

func construct_step() -> void:
	constrution_order[construction_step].visible = true
	construction_step += 1
	if construction_step >= constrution_order.size():
		emit_signal("construction_done")
