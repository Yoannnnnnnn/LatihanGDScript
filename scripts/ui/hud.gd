extends CanvasLayer

@onready var money_label: Label = $StatusPanel/MoneyLabel
@onready var quest_label: Label = $StatusPanel/QuestLabel

var quest_manager

func _ready() -> void:
	quest_manager = get_tree().current_scene.get_node_or_null("QuestManager")

	if quest_manager != null:
		quest_manager.state_changed.connect(_refresh)

	_refresh()

func _refresh() -> void:
	if quest_manager == null:
		return

	money_label.text = "Koin: %d" % quest_manager.money

	if not quest_manager.quest_started:
		quest_label.text = "Quest: -"
	elif quest_manager.quest_completed:
		quest_label.text = "Quest: Selesai"
	else:
		quest_label.text = (
            "Apel: %d/%d"
			% [
				quest_manager.apples_collected,
				quest_manager.APPLES_NEEDED
			]
		)
