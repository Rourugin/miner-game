extends Control

@onready var level: Node2D = $"../.."
@onready var player: CharacterBody2D = $"../../Player"

func _process(_delta: float) -> void:
	if (Input.get_vector("left", "right", "up", "down") or Input.is_action_just_pressed("interact"))\
	and (visible):
		player.play_animation("idle")

func _on_quit_btn_pressed() -> void:
	get_tree().quit()

func _on_continue_btn_pressed() -> void:
	level.pause_game()
