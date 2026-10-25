extends Node

const SETTINGS_PATH := "user://settings.json"

var music_volume: float = 0.8
var sfx_volume: float = 0.8

func _ready() -> void:
	load_settings()
	call_deferred("apply_all_audio")

func set_music_volume(value: float) -> void:
	music_volume = clamp(value, 0.0, 1.0)
	_set_bus_volume("Music", music_volume)
	save_settings()

func set_sfx_volume(value: float) -> void:
	sfx_volume = clamp(value, 0.0, 1.0)
	_set_bus_volume("SFX", sfx_volume)
	save_settings()

func apply_all_audio() -> void:
	_set_bus_volume("Music", music_volume)
	_set_bus_volume("SFX", sfx_volume)

func _set_bus_volume(
	bus_name: String,
	value: float
) -> void:
	var bus_index := AudioServer.get_bus_index(bus_name)

	if bus_index == -1:
		return

	var volume_db: float

	if value <= 0.001:
		volume_db = -80.0
	else:
		volume_db = linear_to_db(value)

	AudioServer.set_bus_volume_db(bus_index, volume_db)

func save_settings() -> void:
	var settings_data := {
		"music_volume": music_volume,
		"sfx_volume": sfx_volume
	}

	var file := FileAccess.open(
		SETTINGS_PATH,
		FileAccess.WRITE
	)

	if file == null:
		print("Pengaturan gagal disimpan.")
		return

	file.store_string(JSON.stringify(settings_data))
	file.close()

func load_settings() -> void:
	if not FileAccess.file_exists(SETTINGS_PATH):
		return

	var file := FileAccess.open(
		SETTINGS_PATH,
		FileAccess.READ
	)

	if file == null:
		return

	var json_text := file.get_as_text()
	file.close()

	var settings_data = JSON.parse_string(json_text)

	if typeof(settings_data) != TYPE_DICTIONARY:
		return

	music_volume = float(
		settings_data.get("music_volume", 0.8)
	)

	sfx_volume = float(
		settings_data.get("sfx_volume", 0.8)
	)
