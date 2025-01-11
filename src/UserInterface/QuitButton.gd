extends Button

#quits the game once the "quit" button is pressed
func _on_button_up() -> void:
	get_tree().quit()
