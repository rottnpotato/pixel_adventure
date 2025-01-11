extends Area2D


@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var coin_sound = $coin
@export var score: = 100


func _on_body_entered(_body: PhysicsBody2D) -> void:
	picked()

#executes when coin/apple is collected
func picked() -> void:
	PlayerData.score += score
	coin_sound.play()
	anim_player.play("picked")
