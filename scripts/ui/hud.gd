extends CanvasLayer

@onready var money_label: Label = $StatusPanel/MoneyLabel
@onready var quest_label: Label = $StatusPanel/QuestLabel
@onready var time_label: Label = $StatusPanel/TimeLabel

var quest_manager
var time_manager

func _ready() -> void:
	quest_manager = get_tree().current_scene.get_node_or_null("QuestManager")
	time_manager = get_tree().current_scene.get_node_or_null("TimeManager")

	if quest_manager != null:
		quest_manager.state_changed.connect(_refresh)

	if time_manager != null:
		time_manager.time_changed.connect(_refresh)

	_refresh()

func _refresh() -> void:
	if quest_manager != null:
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

	if time_manager != null:
		time_label.text = time_manager.get_time_text()
