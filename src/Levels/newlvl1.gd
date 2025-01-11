extends Node2D

@export var mute_distance: float = 100.0  # Distance at which muting starts
@export var mute_speed: float = 2.0  # Speed of volume change

@onready var bgm = $Player/level_theme # Background music player
@onready var portal = $Portal2D  # Reference to the portal
var initial_volume_db: float

func _ready() -> void:

	# Store the initial volume
	initial_volume_db = bgm.volume_db

func _process(delta: float) -> void:
	if bgm and portal:
		var distance = global_position.distance_to(portal.global_position)
		var target_volume = calculate_target_volume(distance)
		
		# Smoothly interpolate the volume
		bgm.volume_db = move_toward(bgm.volume_db, target_volume, mute_speed * delta)

func calculate_target_volume(distance: float) -> float:
	if distance <= mute_distance:
		# Calculate a logarithmic volume reduction
		var volume_reduction = (1.0 - (distance / mute_distance)) * 80  # 80 dB range
		return initial_volume_db - volume_reduction
	else:
		return initial_volume_db
