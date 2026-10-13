extends Area2D

@export var npc_name: String = "Warga"
@export_multiline var dialogue_text: String = "Halo! Selamat datang di kota ini."

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
	if player_nearby and event.is_action_pressed("interact"):
		var dialogue_ui = get_tree().current_scene.get_node_or_null("DialogueUI")

		if dialogue_ui != null:
			dialogue_ui.show_dialogue(npc_name, dialogue_text)

		get_viewport().set_input_as_handled()
