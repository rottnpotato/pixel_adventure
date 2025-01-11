extends ParallaxBackground

@export var scroll_speed: float = 100.0  # Pixels per second
@onready var theme_sound = $theme
var screen_size: Vector2

#code for the auto play parallax background

func _ready():
	screen_size = get_viewport().size
	theme_sound.play()

func _process(delta: float):
	# Move the background to the right
	scroll_offset.x += scroll_speed * delta
	
