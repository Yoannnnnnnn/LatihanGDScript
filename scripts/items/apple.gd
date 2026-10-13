extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not body is CharacterBody2D:
		return

	var quest_manager = get_tree().current_scene.get_node_or_null("QuestManager")

	if quest_manager == null:
		return

	if not quest_manager.quest_started:
		return

	if quest_manager.quest_completed:
		return

	quest_manager.add_apple()
	queue_free()
