extends Node2D

@onready var player_camera: Camera2D = $Player/PlayerCamera
@onready var player: CharacterBody2D = $Player

var home_scene: PackedScene = preload("res://scenes/levels/home_level.tscn")


func _ready() -> void:
	player_camera.limit_left = -250
	player_camera.limit_right = 250
	player_camera.zoom = Vector2(3.0, 3.0)
	var glob_pos
	if Globals.spawn_marker == "home":
		glob_pos = $Markers/GroundHomeMarker.global_position
	elif Globals.spawn_marker == "mine":
		glob_pos = $Markers/GroundMineMarker.global_position
	player.global_position = glob_pos


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_home_area_body_entered(_body: Node2D) -> void:
	get_tree().change_scene_to_packed(home_scene)


func _on_mine_area_body_entered(_body: Node2D) -> void:
	print("Mine entered")
