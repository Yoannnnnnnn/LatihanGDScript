extends Area2D

@export var item_id: String = "apple_01"

var quest_manager

func _ready() -> void:
	body_entered.connect(_on_body_entered)

	quest_manager = get_tree().current_scene.get_node_or_null("QuestManager")

	if quest_manager != null:
		quest_manager.state_changed.connect(_refresh)

	_refresh()

func _on_body_entered(body: Node2D) -> void:
	if not body is CharacterBody2D:
		return

	if quest_manager == null:
		return

	if not quest_manager.quest_started:
		return

	if quest_manager.quest_completed:
		return

	quest_manager.add_apple(item_id)

func _refresh() -> void:
	if quest_manager == null:
		return

	var collected: bool = quest_manager.is_apple_collected(item_id)

	visible = not collected
	set_deferred("monitoring", not collected)

	$CollisionShape2D.set_deferred("disabled", collected)
