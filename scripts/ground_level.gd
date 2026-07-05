extends Node2D

@onready var player_camera: Camera2D = $Player/PlayerCamera
@onready var player: CharacterBody2D = $Player

const HOME_SCENE: PackedScene = preload("res://scenes/levels/home_level.tscn")
const MINE_SCENE: PackedScene = preload("res://scenes/levels/mine_level.tscn")


func _ready() -> void:
	player_camera.limit_left = -250
	player_camera.limit_right = 250
	player_camera.zoom = Vector2(3.0, 3.0)
	var glob_pos
	if Globals.home_spawn_marker:
		glob_pos = $Markers/GroundHomeMarker.global_position
	elif !Globals.home_spawn_marker:
		glob_pos = $Markers/GroundMineMarker.global_position
	player.global_position = glob_pos

func _on_home_area_body_entered(_body: Node2D) -> void:
	get_tree().call_deferred("change_scene_to_packed", HOME_SCENE)

func _on_mine_area_body_entered(_body: Node2D) -> void:
	get_tree().call_deferred("change_scene_to_packed", MINE_SCENE)
