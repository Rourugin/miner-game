extends CanvasLayer

const GROUND_SCENE: PackedScene = preload("res://scenes/levels/ground_level.tscn")

@onready var score_amount: Label = $ScoreContainer/ScoreAmount

func _ready() -> void:
	score_amount.text = str(Globals.score)

func _on_new_btn_pressed() -> void:
	get_tree().reload_current_scene()
	Globals.set_default()
	queue_free()
	get_tree().change_scene_to_packed(GROUND_SCENE)


func _on_quit_btn_pressed() -> void:
	get_tree().quit()
