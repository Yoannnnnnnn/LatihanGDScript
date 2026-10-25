extends CanvasLayer

@onready var pause_panel: Panel = $PausePanel
@onready var resume_button: Button = $PausePanel/ResumeButton
@onready var save_button: Button = $PausePanel/SaveButton
@onready var main_menu_button: Button = $PausePanel/MainMenuButton
@onready var settings_button: Button = $PausePanel/SettingsButton

var is_paused: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	pause_panel.visible = false

	resume_button.pressed.connect(_on_resume_pressed)
	save_button.pressed.connect(_on_save_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	settings_button.pressed.connect(_on_settings_pressed)

func _on_settings_pressed() -> void:
	var settings_ui = get_tree().current_scene.get_node_or_null(
        "SettingsUI"
	)

	if settings_ui != null:
		settings_ui.show_settings()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause_game"):
		_set_paused(not is_paused)

func _set_paused(value: bool) -> void:
	is_paused = value
	get_tree().paused = is_paused
	pause_panel.visible = is_paused

func _on_resume_pressed() -> void:
	_set_paused(false)

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	is_paused = false

	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_save_pressed() -> void:
	var save_manager = get_tree().current_scene.get_node_or_null("SaveManager")

	if save_manager != null:
		save_manager.save_game()
