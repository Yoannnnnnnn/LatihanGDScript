extends CanvasLayer

@onready var dialogue_panel: Panel = $DialoguePanel
@onready var speaker_label: Label = $DialoguePanel/SpeakerLabel
@onready var dialogue_label: Label = $DialoguePanel/DialogueLabel

var is_open: bool = false

func _ready() -> void:
	dialogue_panel.visible = false

func show_dialogue(speaker: String, text: String) -> void:
	speaker_label.text = speaker
	dialogue_label.text = text

	dialogue_panel.visible = true
	is_open = true

func hide_dialogue() -> void:
	dialogue_panel.visible = false
	is_open = false

func _unhandled_input(event: InputEvent) -> void:
	if is_open and event.is_action_pressed("interact"):
		hide_dialogue()
		get_viewport().set_input_as_handled()
