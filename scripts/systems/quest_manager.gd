extends Node

signal state_changed

var quest_started: bool = false
var quest_completed: bool = false
var apples_collected: int = 0
var money: int = 0

var collected_apple_ids: Array[String] = []

const APPLES_NEEDED: int = 3
const QUEST_REWARD: int = 50

func start_apple_quest() -> void:
	if quest_started:
		return

	quest_started = true
	notify_state_changed()

func add_apple(item_id: String) -> void:
	if not quest_started or quest_completed:
		return

	if collected_apple_ids.has(item_id):
		return

	collected_apple_ids.append(item_id)
	apples_collected += 1

	print(
        "Apel dikumpulkan: %d/%d"
		% [apples_collected, APPLES_NEEDED]
	)

	notify_state_changed()

func is_apple_collected(item_id: String) -> bool:
	return collected_apple_ids.has(item_id)

func get_progress_text() -> String:
	return "%d/%d" % [apples_collected, APPLES_NEEDED]

func can_complete() -> bool:
	return (
		quest_started
		and not quest_completed
		and apples_collected >= APPLES_NEEDED
	)

func complete_apple_quest() -> void:
	if not can_complete():
		return

	quest_completed = true
	money += QUEST_REWARD

	print("Quest selesai!")
	print("Uang yang dimiliki: %d" % money)

	notify_state_changed()

func notify_state_changed() -> void:
	state_changed.emit()
