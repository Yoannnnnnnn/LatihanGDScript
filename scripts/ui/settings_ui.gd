extends CanvasLayer

@onready var settings_panel: Panel = $SettingsPanel
@onready var music_slider: HSlider = $SettingsPanel/MusicSlider
@onready var sfx_slider: HSlider = $SettingsPanel/SfxSlider
@onready var close_button: Button = $SettingsPanel/CloseButton

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	settings_panel.visible = false

	music_slider.min_value = 0.0
	music_slider.max_value = 1.0
	music_slider.step = 0.01

	sfx_slider.min_value = 0.0
	sfx_slider.max_value = 1.0
	sfx_slider.step = 0.01

	music_slider.value_changed.connect(_on_music_volume_changed)
	sfx_slider.value_changed.connect(_on_sfx_volume_changed)
	close_button.pressed.connect(hide_settings)

	_refresh_sliders()

func show_settings() -> void:
	settings_panel.visible = true
	_refresh_sliders()

func hide_settings() -> void:
	settings_panel.visible = false

func _on_music_volume_changed(value: float) -> void:
	_set_bus_volume("Music", value)

func _on_sfx_volume_changed(value: float) -> void:
	_set_bus_volume("SFX", value)

func _set_bus_volume(bus_name: String, value: float) -> void:
	var bus_index := AudioServer.get_bus_index(bus_name)

	if bus_index == -1:
		return

	var volume_db: float

	if value <= 0.001:
		volume_db = -80.0
	else:
		volume_db = linear_to_db(value)

	AudioServer.set_bus_volume_db(bus_index, volume_db)

func _refresh_sliders() -> void:
	music_slider.value = _get_bus_volume("Music", 0.8)
	sfx_slider.value = _get_bus_volume("SFX", 0.8)

func _get_bus_volume(
	bus_name: String,
	fallback_value: float
) -> float:
	var bus_index := AudioServer.get_bus_index(bus_name)

	if bus_index == -1:
		return fallback_value

	var volume_db := AudioServer.get_bus_volume_db(bus_index)

	return clamp(db_to_linear(volume_db), 0.0, 1.0)
