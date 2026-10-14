extends Node

signal time_changed

@export var seconds_per_game_minute: float = 5.0

var day: int = 1
var hour: int = 8
var minute: int = 0

var _time_accumulator: float = 0.0

func _process(delta: float) -> void:
	_time_accumulator += delta

	if _time_accumulator >= seconds_per_game_minute:
		_time_accumulator -= seconds_per_game_minute
		advance_minute()

func advance_minute() -> void:
	minute += 1

	if minute >= 60:
		minute = 0
		hour += 1

	if hour >= 24:
		hour = 0
		day += 1

	time_changed.emit()

func get_time_text() -> String:
	return "Hari %d  %02d:%02d" % [day, hour, minute]

func set_time(
	new_day: int,
	new_hour: int,
	new_minute: int
) -> void:
	day = max(new_day, 1)
	hour = clamp(new_hour, 0, 23)
	minute = clamp(new_minute, 0, 59)

	_time_accumulator = 0.0
	time_changed.emit()
