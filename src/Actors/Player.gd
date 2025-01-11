extends Actor

@export var stomp_impulse: = 600.0
@export var hit_delay: = 0.6  # Time in seconds before dying after being hit

@onready var animated_sprite: AnimatedSprite2D = $Sprite
@onready var jump_button: Button = $Joystick/Control/Button
@onready var jump_sound = $jump
@onready var hit_sound = $hit
@onready var stomp_sound = $stomp


var is_hit: = false
var hit_time: = 0.0
var jump_pressed: = false
var touch_jump_pressed: = false
var touch_dictionary: Dictionary = {}

func _ready() -> void:
	jump_button.button_down.connect(_on_jump_button_pressed)
	jump_button.button_up.connect(_on_jump_button_released)

#handle enemy stomp event
func _on_StompDetector_area_entered(_area: Area2D) -> void:
	velocity = calculate_stomp_velocity(velocity, stomp_impulse)

#handle contact with enemy
func _on_EnemyDetector_body_entered(_body: PhysicsBody2D) -> void:
	hit()

func _process(delta: float) -> void:
	if is_hit:
		hit_time += delta
		if hit_time >= hit_delay:
			hit_sound.play()
			die()

#process for map and player position
func _physics_process(delta: float) -> void:
	if is_hit:
		return
		
	super._physics_process(delta)
	var is_jump_interrupted: = velocity.y < 0.0 and not (Input.is_action_pressed("jump") or jump_pressed or touch_jump_pressed)
	var direction: = get_direction()
	velocity = calculate_move_velocity(velocity, direction, speed, is_jump_interrupted)
	var snap: Vector2 = Vector2.DOWN * 60.0 if direction.y == 0.0 else Vector2.ZERO
	move_and_slide()
	set_floor_snap_length(snap.y)
	update_animation(direction)

#handle for touch input(jump button)
func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			# Store the touch in our dictionary
			touch_dictionary[event.index] = event.position
			# Check if this touch is on the jump button
			if jump_button.get_global_rect().has_point(event.position):
				touch_jump_pressed = true
				
		else:
			# Remove the touch from our dictionary
			touch_dictionary.erase(event.index)
			# If no touches remain on the jump button, release it
			var still_touching_jump = false
			for touch_pos in touch_dictionary.values():
				if jump_button.get_global_rect().has_point(touch_pos):
					still_touching_jump = true
					break
			if not still_touching_jump:
				touch_jump_pressed = false

#for player direction
func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0 if is_on_floor() and (Input.is_action_just_pressed("jump") or jump_pressed or touch_jump_pressed) else 0.0
	)

func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		_speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var _velocity: = linear_velocity
	_velocity.x = _speed.x * direction.x
	if direction.y != 0.0:
		_velocity.y = _speed.y * direction.y
	if is_jump_interrupted:
		_velocity.y = 0.0
	return _velocity

func calculate_stomp_velocity(linear_velocity: Vector2, impulse: float) -> Vector2:
	var stomp_jump: = -speed.y if Input.is_action_pressed("jump") or jump_pressed or touch_jump_pressed else -impulse
	return Vector2(linear_velocity.x, stomp_jump)

#handle if player is hit by enemy
func hit() -> void:
	is_hit = true
	hit_time = 0.0
	stomp_sound.play()
	animated_sprite.play("hit")
	
#player deaths counter
func die() -> void:
	PlayerData.deaths += 1
	queue_free()

#animation for each sprite character action
func update_animation(direction: Vector2) -> void:
	if is_hit:
		return
	if not is_on_floor():
		animated_sprite.play("jump")
	elif direction.x != 0:
		animated_sprite.play("run")
		animated_sprite.flip_h = direction.x < 0
	else:
		animated_sprite.play("idle")

#two functions for registering jump input from touch screen
func _on_jump_button_pressed() -> void:
	jump_pressed = true
	Input.action_press("jump")
	jump_sound.play()

func _on_jump_button_released() -> void:
	jump_pressed = false
	Input.action_release("jump")
