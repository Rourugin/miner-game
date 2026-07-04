extends Node2D

@onready var player_camera: Camera2D = $Player/PlayerCamera
@onready var player: CharacterBody2D = $Player

var entered_area: Area2D = null


func _ready() -> void:
	player_camera.limit_left = -125
	player_camera.limit_right = 200
	player_camera.zoom = Vector2(6.0, 6.0)
	player.global_position = $Markers/Marker2D.global_position

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") and entered_area != null:
		_upgrade(entered_area)

func _upgrade(object: Area2D) -> void:
	print("upgrade")
	print(object)

func _on_ground_area_body_entered(_body: Node2D) -> void:
	get_tree().change_scene_to_file("res://scenes/levels/ground_level.tscn")

func _on_pickaxe_area_body_entered(_body: Node2D) -> void:
	entered_area = $Areas/UpgradeAreas/PickaxeArea

func _on_pickaxe_area_body_exited(_body: Node2D) -> void:
	entered_area = null

func _on_reinforcement_area_body_entered(_body: Node2D) -> void:
	entered_area = $Areas/UpgradeAreas/ReinforcementArea

func _on_reinforcement_area_body_exited(_body: Node2D) -> void:
	entered_area = null

func _on_vision_area_body_entered(_body: Node2D) -> void:
	entered_area = $Areas/UpgradeAreas/VisionArea

func _on_vision_area_body_exited(_body: Node2D) -> void:
	entered_area = null
