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

	music_slider.value_changed.connect(
		_on_music_volume_changed
	)

	sfx_slider.value_changed.connect(
		_on_sfx_volume_changed
	)

	close_button.pressed.connect(hide_settings)

	_refresh_sliders()

func show_settings() -> void:
	settings_panel.visible = true
	_refresh_sliders()

func hide_settings() -> void:
	settings_panel.visible = false

func _on_music_volume_changed(value: float) -> void:
	SettingsManager.set_music_volume(value)

func _on_sfx_volume_changed(value: float) -> void:
	SettingsManager.set_sfx_volume(value)

func _refresh_sliders() -> void:
	music_slider.set_value_no_signal(
		SettingsManager.music_volume
	)

	sfx_slider.set_value_no_signal(
		SettingsManager.sfx_volume
	)
