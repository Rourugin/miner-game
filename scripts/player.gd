extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


const SPEED = 100.0

var last_direction: Vector2

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	_process_movement(direction)

	move_and_slide()

func _process_movement(direction: Vector2) -> void:
	match direction:
		Vector2.ZERO:
			velocity = Vector2.ZERO
			_play_animation("idle")
		Vector2.RIGHT, Vector2.LEFT:
			velocity = direction * SPEED
			last_direction = direction
			_play_animation("run")
		Vector2.UP, Vector2.DOWN:
			if get_tree().current_scene.name == "ground_level":
				velocity = Vector2.ZERO
				_play_animation("idle")
		
func _play_animation(anim: String) -> void:
	if anim == "idle":
		animated_sprite_2d.play("idle")
	elif anim == "run":
		animated_sprite_2d.play("run")
		if last_direction == Vector2.RIGHT:
			animated_sprite_2d.flip_h = false
			collision_shape_2d.position.x = abs(collision_shape_2d.position.x)
		elif last_direction == Vector2.LEFT:
			animated_sprite_2d.flip_h = true
			collision_shape_2d.position.x = abs(collision_shape_2d.position.x) * -1
