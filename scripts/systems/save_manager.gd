extends Node

const SAVE_PATH := "user://mini_life_rpg_save.json"

var player
var quest_manager
var time_manager

func _refresh_references() -> void:
	var current_scene = get_tree().current_scene

	if current_scene == null:
		return

	player = current_scene.get_node_or_null("Player")
	quest_manager = current_scene.get_node_or_null("QuestManager")
	time_manager = current_scene.get_node_or_null("TimeManager")

func _ready() -> void:
	_refresh_references()

	print("Tekan K untuk menyimpan game.")
	print("Tekan L untuk memuat game.")

	var scene_tree: SceneTree = get_tree()

	if scene_tree.has_meta(
        "load_save_after_scene_change"
	):
		scene_tree.remove_meta(
            "load_save_after_scene_change"
		)

		print("SaveManager akan memuat save.")
		call_deferred("load_game")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("save_game"):
		save_game()
		get_viewport().set_input_as_handled()

	elif event.is_action_pressed("load_game"):
		load_game()
		get_viewport().set_input_as_handled()

func save_game() -> void:
	_refresh_references()

	if (
		player == null
		or quest_manager == null
		or time_manager == null
	):
		print("Save gagal: node penting tidak ditemukan.")
		return

	var save_data := {
		"player_position": {
			"x": player.position.x,
			"y": player.position.y
		},
		"quest_started": quest_manager.quest_started,
		"quest_completed": quest_manager.quest_completed,
		"apples_collected": quest_manager.apples_collected,
		"money": quest_manager.money,
		"collected_apple_ids": quest_manager.collected_apple_ids,
		"day": time_manager.day,
		"hour": time_manager.hour,
		"minute": time_manager.minute
	}

	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)

	if file == null:
		print("Save gagal dibuat.")
		return

	file.store_string(JSON.stringify(save_data))
	file.close()

	print("Game berhasil disimpan.")
	print("Posisi tersimpan: ", player.position)

func load_game() -> void:
	_refresh_references()

	if (
		player == null
		or quest_manager == null
		or time_manager == null
	):
		print("Load gagal: node penting tidak ditemukan.")
		return

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)

	if file == null:
		print("File save gagal dibuka.")
		return

	var json_text := file.get_as_text()
	file.close()

	var save_data = JSON.parse_string(json_text)

	if typeof(save_data) != TYPE_DICTIONARY:
		print("Data save rusak.")
		return

	var saved_position = save_data.get("player_position", {})

	player.position = Vector2(
		float(saved_position.get("x", player.position.x)),
		float(saved_position.get("y", player.position.y))
	)

	quest_manager.quest_started = bool(
		save_data.get("quest_started", false)
	)

	quest_manager.quest_completed = bool(
		save_data.get("quest_completed", false)
	)

	quest_manager.apples_collected = int(
		save_data.get("apples_collected", 0)
	)

	quest_manager.money = int(
		save_data.get("money", 0)
	)

	quest_manager.collected_apple_ids.clear()

	var saved_apple_ids = save_data.get("collected_apple_ids", [])

	for item_id in saved_apple_ids:
		quest_manager.collected_apple_ids.append(str(item_id))

	time_manager.set_time(
		int(save_data.get("day", 1)),
		int(save_data.get("hour", 8)),
		int(save_data.get("minute", 0))
	)

	quest_manager.notify_state_changed()

	print("Game berhasil dimuat.")
	print("Posisi dimuat: ", player.position)
	print("Apel dimuat: ", quest_manager.apples_collected)
	print("Koin dimuat: ", quest_manager.money)
