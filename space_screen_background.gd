extends Sprite2D

# screenshake
@onready var noise = FastNoiseLite.new()
const SHAKE_DURATION := 0.5
var noise_y = 0
var shake_start: int = 0
const max_offset := Vector2(60, 7)  # Maximum hor/ver shake in pixels.
const max_roll := 0.05  # Maximum rotation in radians (use sparingly).

var original_pos: Vector2

func _ready():
	randomize()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.seed = randi()
	noise.fractal_octaves = 2
	original_pos = position
	set_process(false)

func _process(delta: float) -> void:
	var progress = (Time.get_ticks_msec() - shake_start) / (SHAKE_DURATION * 1000.0)
	if progress >= 1:
		rotation = 0
		position = original_pos
		set_process(false)
		return
	
	var amplitude = 1 - progress
	noise_y += 2
	rotation = max_roll * amplitude * noise.get_noise_2d(noise.seed, noise_y)
	var pos_offset = Vector2(
		max_offset.x * amplitude * noise.get_noise_2d(noise.seed*2, noise_y),
		max_offset.y * amplitude * noise.get_noise_2d(noise.seed*3, noise_y)
	)
	position = original_pos + pos_offset

func shake() -> void:
	shake_start = Time.get_ticks_msec()
	set_process(true)
