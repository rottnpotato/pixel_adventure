extends Actor

@onready var stomp_area: Area2D = $StompArea2D
@onready var animated_sprite: AnimatedSprite2D = $Sprite
@onready var hit_sound = $hit

@export var score: = 100
@export var hit_delay: = 0.4  # Time in seconds before dying after being hit

var is_hit: = false
var hit_time: = 0.0

func _ready() -> void:
	velocity.x = -speed.x
	animated_sprite.play("run")

func _process(delta: float) -> void:
	if is_hit:
		hit_time += delta
		if hit_time >= hit_delay:
			die()

func _physics_process(delta: float) -> void:
	if is_hit:
		return

	super._physics_process(delta)
	
	if is_on_wall():
		velocity.x *= -1
		animated_sprite.flip_h = velocity.x > 0
	
	if abs(velocity.x) > 0:
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")
	
	move_and_slide()

#detects entry on collision with player(stomp collision)
func _on_StompArea2D_area_entered(area: Area2D) -> void:
	if area.global_position.y > stomp_area.global_position.y:
		return
	hit()

#function if enemy is hit
func hit() -> void:
	is_hit = true
	hit_time = 0.0
	velocity = Vector2.ZERO
	hit_sound.play()
	animated_sprite.play("hit")

func die() -> void:
	PlayerData.score += score
	queue_free()
