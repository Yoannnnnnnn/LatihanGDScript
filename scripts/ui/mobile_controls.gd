extends CanvasLayer

@onready var action_buttons := {
	"move_up": $DPad/Up,
	"move_left": $DPad/Left,
	"move_down": $DPad/Down,
	"move_right": $DPad/Right
}

@onready var interact_button: Button = $InteractButton
@onready var inventory_button: Button = $InventoryButton
@onready var d_pad: Control = $DPad
@onready var pause_button: Button = $PauseButton

var dialogue_ui

func _ready() -> void:
	for action_name in action_buttons:
		var button: Button = action_buttons[action_name]

		button.button_down.connect(
			_press_action.bind(action_name)
		)

		button.button_up.connect(
			_release_action.bind(action_name)
		)

	# E dan I menggunakan input satu kali tekan.
	interact_button.pressed.connect(
		_trigger_action.bind("interact")
	)

	inventory_button.pressed.connect(
		_trigger_action.bind("inventory")
	)
	
	pause_button.pressed.connect(
	_trigger_action.bind("pause_game")
	)
	
	dialogue_ui = get_tree().current_scene.get_node_or_null("DialogueUI")

func _press_action(action_name: String) -> void:
	Input.action_press(action_name)

func _release_action(action_name: String) -> void:
	Input.action_release(action_name)

func _trigger_action(action_name: String) -> void:
	Input.action_press(action_name)

	# Menahan action selama satu frame agar dapat terbaca oleh script lain.
	await get_tree().process_frame

	Input.action_release(action_name)

func _process(_delta: float) -> void:
	if dialogue_ui == null:
		return

	var dialogue_open: bool = dialogue_ui.is_open

	d_pad.visible = not dialogue_open
	inventory_button.visible = not dialogue_open

	# Tombol E tetap terlihat ketika dialog terbuka.
	interact_button.visible = true

func _exit_tree() -> void:
	for action_name in action_buttons:
		Input.action_release(action_name)

	Input.action_release("interact")
	Input.action_release("inventory")
	Input.action_release("pause_game")
