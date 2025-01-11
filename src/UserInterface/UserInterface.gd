extends Node

# Node references
@onready var scene_tree: SceneTree = get_tree()
@onready var score_label: Label = $Score
@onready var pause_overlay: ColorRect = $PauseOverlay
@onready var title_label: Label = $PauseOverlay/Title
@onready var main_screen_button: Button = $PauseOverlay/PauseMenu/MainScreenButton
@onready var pause_button: Button = $pause

# Constants
const MESSAGE_DIED: String = "You died"

# Properties
var paused: bool = false:
	set(value):
		paused = value
		scene_tree.paused = value
		pause_overlay.visible = value

func _ready() -> void:
	# Connect signals
	PlayerData.updated.connect(update_interface)
	PlayerData.died.connect(_on_Player_died)
	PlayerData.reset.connect(_on_Player_reset)
	pause_button.pressed.connect(_on_pause_button_pressed)
	update_interface()

func _on_Player_died() -> void:
	self.paused = true
	title_label.text = MESSAGE_DIED

func _on_Player_reset() -> void:
	self.paused = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and title_label.text != MESSAGE_DIED:
		self.paused = not paused

func update_interface() -> void:
	score_label.text = "Score: %s" % PlayerData.score

# New function to handle pause button press
func _on_pause_button_pressed() -> void:
	# Create and trigger a new InputEventAction
	var event = InputEventAction.new()
	event.action = "pause"
	event.pressed = true
	Input.parse_input_event(event)
