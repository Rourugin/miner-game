extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D

const SPEED = 300.0

var last_direction: Vector2

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	_process_movement(direction)

	move_and_slide()

func _process_movement(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
		last_direction = direction
		_play_animation("run")
	elif direction == Vector2.ZERO:
		_play_animation("idle")
		
func _play_animation(anim: String) -> void:
	if anim == "idle":
		animated_sprite_2d.play("idle")
	elif anim == "run":
		animated_sprite_2d.play("run")
		if last_direction == Vector2.RIGHT:
			animated_sprite_2d.flip_h = false
			collision_polygon_2d.position.x = abs(collision_polygon_2d.position.x)
		elif last_direction == Vector2.LEFT:
			animated_sprite_2d.flip_h = true
			collision_polygon_2d.position.x = abs(collision_polygon_2d.position.x) * -1
