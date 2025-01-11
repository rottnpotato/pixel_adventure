extends Node2D

@onready var virtual_joystick = $CanvasLayer/VirtualJoystick
@onready var player = $Player  # Assuming you have a player node
@export var player_speed: float = 200.0  # Adjust as needed

func _ready() -> void:
	# Ensure the joystick is visible when the level starts
	virtual_joystick.show()

func _process(delta: float) -> void:
	handle_joystick_input(delta)

func handle_joystick_input(delta: float) -> void:
	# Get the joystick strength and direction
	var movement = Vector2.ZERO
	if virtual_joystick.is_pressed():
		movement = Vector2(
			virtual_joystick.get_value().x,
			virtual_joystick.get_value().y
		)
	
	# Move the player based on joystick input
	if player and movement.length() > 0:
		player.position += movement * player_speed * delta
