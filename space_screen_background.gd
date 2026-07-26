extends Sprite2D

# screenshake
@onready var noise = FastNoiseLite.new()
const SHAKE_DURATION := 0.4
var noise_y = 0
var shake_start: int = 0
var amplitude := 0  # [0, 1]
const decay := 0.8  # How quickly the shaking stops [0, 1].
const max_offset := Vector2(100, 75)  # Maximum hor/ver shake in pixels.
const max_roll := 0.1  # Maximum rotation in radians (use sparingly).

func _ready():
	randomize()
	noise.seed = randi()
	noise.fractal_octaves = 2
	set_process(false)

func _process(delta: float) -> void:
	if Time.get_ticks_msec() > shake_start + SHAKE_DURATION * 1000:
		set_process(false)
	noise_y += 1
	rotation = max_roll * amplitude * noise.get_noise_2d(noise.seed, noise_y)
	offset.x = max_offset.x * amplitude * noise.get_noise_2d(noise.seed*2, noise_y)
	offset.y = max_offset.y * amplitude * noise.get_noise_2d(noise.seed*3, noise_y)
	amplitude -= delta * decay

func shake() -> void:
	shake_start = Time.get_ticks_msec()
	set_process(true)
