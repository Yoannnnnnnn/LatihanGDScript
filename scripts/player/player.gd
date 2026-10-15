extends CharacterBody2D

@export var speed: float = 120.0

@onready var animated_sprite: AnimatedSprite2D = $PlayerAnimatedSprite

var last_direction: Vector2 = Vector2.DOWN

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
        "move_down"
	)

	velocity = direction * speed

	if direction == Vector2.ZERO:
		_play_idle_animation()
	else:
		last_direction = direction
		_play_walk_animation(direction)

	move_and_slide()

func _play_walk_animation(direction: Vector2) -> void:
	if abs(direction.x) > abs(direction.y):
		animated_sprite.play("walk_side")
		animated_sprite.flip_h = direction.x < 0

	elif direction.y > 0:
		animated_sprite.play("walk_down")
		animated_sprite.flip_h = false

	else:
		animated_sprite.play("walk_up")
		animated_sprite.flip_h = false

func _play_idle_animation() -> void:
	if abs(last_direction.x) > abs(last_direction.y):
		animated_sprite.play("idle_side")
		animated_sprite.flip_h = last_direction.x < 0

	elif last_direction.y > 0:
		animated_sprite.play("idle_down")
		animated_sprite.flip_h = false

	else:
		animated_sprite.play("idle_up")
		animated_sprite.flip_h = false
