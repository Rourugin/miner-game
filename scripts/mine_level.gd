extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var player_camera: Camera2D = $Player/PlayerCamera

func _ready() -> void:
	player_camera.limit_left = -10000
	player_camera.limit_right = 10000
	player_camera.zoom = Vector2(10.0, 10.0)
	player.global_position = $Markers/SpawnMarker.global_position
	Globals.home_spawn_marker = false


func _on_ground_area_body_entered(_body: Node2D) -> void:
	get_tree().change_scene_to_file("res://scenes/levels/ground_level.tscn")


#1алмаз 2ялпаит 3железо 4золото 5магнезит 6свинец 7свинец 8серебро 9уран 10церуссит
