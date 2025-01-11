@tool
extends Button

@export_file var next_scene_path: = ""

func _ready() -> void:
	# Connect to both button_up (mouse/keyboard) and gui_input (touch) signals
	connect("button_up", on_button_up)
	connect("gui_input", on_gui_input)

func on_button_up() -> void:
	#_handle_activation()
	print("")

func on_gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed == false:  # Touch released
			_handle_activation()

func _handle_activation() -> void:
	PlayerData.reset_data()
	get_tree().change_scene_to_file(next_scene_path)

func _get_configuration_warning() -> String:
	return "The property Next Level can't be empty" if next_scene_path == "" else ""
