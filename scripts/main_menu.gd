extends Control

const GROUND_SCENE: PackedScene = preload("res://scenes/levels/ground_level.tscn")

func _on_start_btn_pressed() -> void:
	get_tree().change_scene_to_packed(GROUND_SCENE)


func _on_quit_btn_pressed() -> void:
	get_tree().quit()
