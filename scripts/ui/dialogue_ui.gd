extends CanvasLayer

@onready var dialogue_panel: Panel = $DialoguePanel
@onready var speaker_label: Label = $DialoguePanel/SpeakerLabel
@onready var dialogue_label: Label = $DialoguePanel/DialogueLabel
@onready var hint_label: Label = $DialoguePanel/HintLabel

var dialogue_lines: PackedStringArray = []
var current_line: int = 0
var is_open: bool = false
var ignore_next_interact: bool = false

func _ready() -> void:
	dialogue_panel.visible = false
	hint_label.text = "E - Tutup"

func show_dialogue(speaker: String, text: String) -> void:
	if is_open:
		return

	dialogue_lines = text.split("\n", false)

	if dialogue_lines.is_empty():
		dialogue_lines.append(text)

	current_line = 0

	speaker_label.text = speaker
	dialogue_label.text = dialogue_lines[current_line]

	dialogue_panel.visible = true
	is_open = true

	# Mencegah tombol E yang membuka dialog
	# langsung melanjutkan dialog.
	ignore_next_interact = true

	_update_hint()

func hide_dialogue() -> void:
	dialogue_panel.visible = false
	is_open = false
	dialogue_lines.clear()
	current_line = 0

func _process(_delta: float) -> void:
	if ignore_next_interact:
		ignore_next_interact = false
		return

	if not is_open:
		return

	if not Input.is_action_just_pressed("interact"):
		return

	current_line += 1

	if current_line >= dialogue_lines.size():
		hide_dialogue()
	else:
		dialogue_label.text = dialogue_lines[current_line]
		_update_hint()

func _update_hint() -> void:
	if current_line < dialogue_lines.size() - 1:
		hint_label.text = "E - Lanjut"
	else:
		hint_label.text = "E - Tutup"
