extends Node2D

@onready var player_camera: Camera2D = $Player/PlayerCamera
@onready var player: CharacterBody2D = $Player


func _ready() -> void:
	player_camera.limit_left = -125
	player_camera.limit_right = 200
	player_camera.zoom = Vector2(6.0, 6.0)
	player.global_position = $Markers/Marker2D.global_position

func _process(_delta: float) -> void:
	pass

func _on_ground_area_body_entered(_body: Node2D) -> void:
	get_tree().change_scene_to_file("res://scenes/levels/ground_level.tscn")
