extends Node

var quest_started: bool = false
var quest_completed: bool = false
var apples_collected: int = 0
var money: int = 0

const APPLES_NEEDED: int = 3
const QUEST_REWARD: int = 50

func start_apple_quest() -> void:
	quest_started = true

func add_apple() -> void:
	if not quest_started or quest_completed:
		return

	apples_collected += 1

	print(
        "Apel dikumpulkan: %d/%d"
		% [apples_collected, APPLES_NEEDED]
	)

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
