extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var last_direction: Vector2

var is_playing_animation: bool = false


func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	
	_process_movement(direction)
	move_and_slide()

func _process_movement(direction: Vector2) -> void:
	match direction:
		Vector2.ZERO:
			velocity = Vector2.ZERO
			play_animation("idle")
		Vector2.RIGHT, Vector2.LEFT:
			velocity = direction * Globals.speed
			last_direction = direction
			play_animation("run")
		Vector2.DOWN:
			if get_tree().current_scene.name == "MineLevel":
				velocity = direction * Globals.speed
				last_direction = direction
		Vector2.UP:
			if get_tree().current_scene.name == "MineLevel" and global_position.y > -208:
				velocity = direction * Globals.speed
				last_direction = direction
		
func play_animation(anim: String) -> void:
	match anim:
		"idle":
			if not is_playing_animation:
				animated_sprite_2d.play("idle")
		"run":
			animated_sprite_2d.play("run")
			if last_direction == Vector2.RIGHT:
				animated_sprite_2d.flip_h = false
				collision_shape_2d.position.x = abs(collision_shape_2d.position.x)
			elif last_direction == Vector2.LEFT:
				animated_sprite_2d.flip_h = true
				collision_shape_2d.position.x = abs(collision_shape_2d.position.x) * -1
		"hit":
			is_playing_animation = true
			match last_direction:
				Vector2.RIGHT:
					animated_sprite_2d.flip_h = false
					collision_shape_2d.position.x = abs(collision_shape_2d.position.x)
					animated_sprite_2d.play("hit_side")
					collision_shape_2d.position.x = abs(collision_shape_2d.position.x) * -1
				Vector2.LEFT:
					animated_sprite_2d.flip_h = true
					animated_sprite_2d.play("hit_side")
				Vector2.UP:
					animated_sprite_2d.play("hit_up")
				Vector2.DOWN:
					animated_sprite_2d.play("hit_down")
			await animated_sprite_2d.animation_finished
			is_playing_animation = false
