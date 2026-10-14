extends Area2D

@export var npc_name: String = "Warga"
@export_multiline var dialogue_text: String = "Halo! Selamat datang di kota ini."
@export var quest_giver: bool = false

@export var schedule_enabled: bool = false
@export_range(0, 23, 1) var active_from_hour: int = 8
@export_range(0, 23, 1) var active_until_hour: int = 18

@export var location_schedule_enabled: bool = false
@export var work_position: Vector2 = Vector2(700, 324)
@export var home_position: Vector2 = Vector2(900, 520)

@export_range(0.1, 10.0, 0.1)
var travel_duration: float = 2.0

var player_nearby: bool = false
var is_available: bool = true
var time_manager
var movement_tween: Tween
var is_moving: bool = false

@onready var prompt: Label = $Prompt

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	time_manager = get_tree().current_scene.get_node_or_null("TimeManager")

	if time_manager != null:
		time_manager.time_changed.connect(_update_schedule)

	_update_schedule()

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_nearby = true
		_update_prompt()

func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_nearby = false
		_update_prompt()

func _unhandled_input(event: InputEvent) -> void:
	if not player_nearby:
		return

	if is_moving:
		return

	if not is_available:
		return

	if not event.is_action_pressed("interact"):
		return

	var dialogue_ui = get_tree().current_scene.get_node_or_null("DialogueUI")

	if dialogue_ui != null and not dialogue_ui.is_open:
		var current_dialogue := _get_current_dialogue()

		dialogue_ui.show_dialogue(npc_name, current_dialogue)
		get_viewport().set_input_as_handled()

func _update_schedule() -> void:
	if not schedule_enabled:
		is_available = true
	elif time_manager != null:
		is_available = _is_hour_available(time_manager.hour)
	else:
		is_available = true

	if location_schedule_enabled and schedule_enabled:
		var target_position: Vector2

		if is_available:
			target_position = work_position
		else:
			target_position = home_position

		if position.distance_to(target_position) > 0.1:
			_move_to(target_position)

	_update_prompt()

func _move_to(target_position: Vector2) -> void:
	if movement_tween != null and movement_tween.is_valid():
		movement_tween.kill()

	is_moving = true
	_update_prompt()

	movement_tween = create_tween()
	movement_tween.set_trans(Tween.TRANS_SINE)
	movement_tween.set_ease(Tween.EASE_IN_OUT)

	movement_tween.tween_property(
		self,
		"position",
		target_position,
		travel_duration
	)

	movement_tween.finished.connect(_on_movement_finished)

func _on_movement_finished() -> void:
		is_moving = false
		_update_prompt()

func _is_hour_available(current_hour: int) -> bool:
	if active_from_hour < active_until_hour:
		return (
			current_hour >= active_from_hour
			and current_hour < active_until_hour
		)

	# Mendukung jadwal yang melewati tengah malam.
	return (
		current_hour >= active_from_hour
		or current_hour < active_until_hour
	)

func _update_prompt() -> void:
	if not player_nearby:
		prompt.visible = false
		return

	prompt.visible = true

	if is_moving:
		prompt.text = "..."
	elif is_available:
		prompt.text = "E - Bicara"
	else:
		prompt.text = "Tutup"

func _get_current_dialogue() -> String:
	if not quest_giver:
		return dialogue_text

	var quest_manager = get_tree().current_scene.get_node_or_null("QuestManager")

	if quest_manager == null:
		return dialogue_text

	if not quest_manager.quest_started:
		quest_manager.start_apple_quest()

		return (
            "Tolong kumpulkan 3 apel untuk saya.\n"
			+ "Kamu dapat menemukannya di sekitar kota."
		)

	if quest_manager.quest_completed:
		return "Terima kasih sudah membantu saya."

	if quest_manager.can_complete():
		quest_manager.complete_apple_quest()

		return (
            "Kamu berhasil mengumpulkan semua apel.\n"
			+ "Ini hadiah 50 koin untukmu."
		)

	return (
        "Kamu baru membawa "
		+ quest_manager.get_progress_text()
		+ " apel.\n"
		+ "Kumpulkan semuanya lalu kembali ke sini."
	)
