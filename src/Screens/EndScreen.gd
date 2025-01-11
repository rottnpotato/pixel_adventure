extends Control


@onready var result: Label = $Result

#displays player stats
func _ready() -> void:
	result.text = result.text % [PlayerData.score, PlayerData.deaths]
