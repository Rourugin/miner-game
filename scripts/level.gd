extends Node2D
class_name Level

@onready var pause_menu: Control = $PauseLayer/PauseMenu

var paused: bool = false


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pause_game()

func pause_game() -> void:
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	elif !paused:
		pause_menu.show()
		Engine.time_scale = 0
	
	paused = !paused
