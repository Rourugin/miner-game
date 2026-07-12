extends Level

@onready var player_camera: Camera2D = $Player/PlayerCamera
@onready var player: CharacterBody2D = $Player
@onready var door_player: AudioStreamPlayer2D = $AudioPlayers/DoorPlayer
@onready var elevator_player: AudioStreamPlayer2D = $AudioPlayers/ElevatorPlayer

const HOME_SCENE: PackedScene = preload("res://scenes/levels/home_level.tscn")
const MINE_SCENE: PackedScene = preload("res://scenes/levels/mine_level.tscn")
const PAUSE_SCENE: PackedScene = preload("res://scenes/ui/pause_menu.tscn")


func _ready() -> void:
	_prepare()
	var glob_pos
	if Globals.home_spawn_marker:
		glob_pos = $Markers/GroundHomeMarker.global_position
	elif !Globals.home_spawn_marker:
		glob_pos = $Markers/GroundMineMarker.global_position
	player.global_position = glob_pos

func _on_home_area_body_entered(_body: Node2D) -> void:
	door_player.play()
	await door_player.finished
	get_tree().call_deferred("change_scene_to_packed", HOME_SCENE)

func _prepare() -> void:
	player_camera.limit_left = -250
	player_camera.limit_right = 425
	player_camera.zoom = Vector2(3.0, 3.0)

func _on_mine_area_body_entered(_body: Node2D) -> void:
	elevator_player.play()
	#await elevator_player.finished
	get_tree().call_deferred("change_scene_to_packed", MINE_SCENE)
