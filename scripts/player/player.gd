extends CharacterBody2D

@export var speed: float = 120.0

@onready var animated_sprite: AnimatedSprite2D = $PlayerAnimatedSprite

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
        "move_down"
	)

	velocity = direction * speed

	if direction == Vector2.ZERO:
		animated_sprite.play("idle")
	else:
		animated_sprite.play("walk")

	move_and_slide()
