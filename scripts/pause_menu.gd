extends Control

@onready var level: Node2D = $".."

func _on_quit_btn_pressed() -> void:
	get_tree().quit()

func _on_continue_btn_pressed() -> void:
	level.pause_game()
