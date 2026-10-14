extends CanvasLayer

@onready var night_overlay: ColorRect = $NightOverlay

var time_manager

func _ready() -> void:
	time_manager = get_tree().current_scene.get_node_or_null("TimeManager")

	if time_manager != null:
		time_manager.time_changed.connect(_update_overlay)

	_update_overlay()

func _update_overlay() -> void:
	if time_manager == null:
		return

	var current_hour: int = time_manager.hour

	if current_hour >= 6 and current_hour < 17:
		# Siang
		night_overlay.color = Color(0.0, 0.0, 0.0, 0.0)

	elif current_hour >= 17 and current_hour < 19:
		# Sore
		night_overlay.color = Color(0.35, 0.12, 0.02, 0.18)

	elif current_hour >= 19 and current_hour < 21:
		# Senja
		night_overlay.color = Color(0.12, 0.06, 0.20, 0.28)

	else:
		# Malam
		night_overlay.color = Color(0.02, 0.03, 0.14, 0.45)
