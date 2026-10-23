extends Control

const SAVE_PATH := "user://mini_life_rpg_save.json"

@onready var start_button: Button = $StartButton
@onready var continue_button: Button = $ContinueButton
@onready var quit_button: Button = $QuitButton

func _ready() -> void:
	start_button.pressed.connect(_on_start_pressed)
	continue_button.pressed.connect(_on_continue_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

	continue_button.visible = FileAccess.file_exists(SAVE_PATH)

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file(
        "res://scenes/main.tscn"
	)

func _on_continue_pressed() -> void:
	print("Continue ditekan")

	var scene_tree: SceneTree = get_tree()

	# Memberi tanda bahwa scene Main harus memuat save.
	scene_tree.set_meta(
		"load_save_after_scene_change",
		true
	)

	var error := scene_tree.change_scene_to_file(
        "res://scenes/main.tscn"
	)

	if error != OK:
		scene_tree.remove_meta(
            "load_save_after_scene_change"
		)

		print("Gagal membuka game.")

func _on_quit_pressed() -> void:
	get_tree().quit()
