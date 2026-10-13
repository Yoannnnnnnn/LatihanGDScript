extends CanvasLayer

@onready var inventory_panel: Panel = $InventoryPanel
@onready var apple_label: Label = $InventoryPanel/AppleLabel

var quest_manager

func _ready() -> void:
	inventory_panel.visible = false

	quest_manager = get_tree().current_scene.get_node_or_null("QuestManager")

	if quest_manager != null:
		quest_manager.state_changed.connect(_refresh)

	_refresh()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		inventory_panel.visible = not inventory_panel.visible

		if inventory_panel.visible:
			_refresh()

		get_viewport().set_input_as_handled()

func _refresh() -> void:
	if quest_manager == null:
		return

	apple_label.text = "Apel: %d" % quest_manager.apples_collected
