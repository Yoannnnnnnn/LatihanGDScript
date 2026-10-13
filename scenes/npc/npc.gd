extends Area2D

@export var npc_name: String = "Warga"
@export_multiline var dialogue_text: String = "Halo! Selamat datang di kota ini."
@export var quest_giver: bool = false

var player_nearby: bool = false

@onready var prompt: Label = $Prompt

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_nearby = true
		prompt.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_nearby = false
		prompt.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if not player_nearby:
		return

	if not event.is_action_pressed("interact"):
		return

	var dialogue_ui = get_tree().current_scene.get_node_or_null("DialogueUI")

	if dialogue_ui != null and not dialogue_ui.is_open:
		var current_dialogue := _get_current_dialogue()

		dialogue_ui.show_dialogue(npc_name, current_dialogue)
		get_viewport().set_input_as_handled()

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
