extends Level

@onready var player_camera: Camera2D = $Player/PlayerCamera
@onready var player: CharacterBody2D = $Player
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioPlayers/AudioStreamPlayer2D

var entered_area: Area2D = null


func _ready() -> void:
	_prepare()
	player.global_position = $Markers/SpawnMarker.global_position
	Globals.home_spawn_marker = true

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") and entered_area != null:
		_upgrade(entered_area)

func _upgrade(area: Area2D) -> void:
	match area.name:
		"PickaxeArea":
			if Globals.gold >= Globals.prices[0]:
				Globals.gold -= Globals.prices[0]
				Globals.pickaxe_damage += 1
				Globals.prices[0] *= 3.0
				Globals.score += 20
			elif Globals.gold < Globals.prices[0]:
				print("Not enough money")
		"ReinforcementArea":
			if Globals.gold >= Globals.prices[1]:
				Globals.gold -= Globals.prices[1]
				Globals.reinforcements += 1
				print(Globals.reinforcements)
			elif Globals.gold < Globals.prices[1]:
				print("Not enough money")
		"VisionArea":
			if Globals.gold >= Globals.prices[2]:
				Globals.gold -= Globals.prices[2]
				Globals.prices[2] *= 1.25
				Globals.zoom -= Vector2(1.5, 1.5)
				Globals.score += 12
				print(Globals.zoom)
			elif Globals.gold < Globals.prices[2]:
				print("Not enough money")
		"SpeedArea":
			if Globals.gold >= Globals.prices[3]:
				Globals.gold -= Globals.prices[3]
				Globals.prices[3] *= 1.5
				Globals.speed += 10.0
				Globals.score += 10
				print(Globals.speed)
			elif Globals.gold < Globals.prices[3]:
				print("Not enough money")
		"DurationArea":
			if Globals.gold >= Globals.prices[4]:
				Globals.gold -= Globals.prices[4]
				Globals.prices[4] *= 2.0
				Globals.extra_duration += 10.0
				Globals.score += 15
				print(Globals.extra_duration)
			elif Globals.gold < Globals.prices[4]:
				print("Not enough money")

func _prepare() -> void:
	player_camera.limit_left = -125
	player_camera.limit_right = 464
	player_camera.zoom = Vector2(6.0, 6.0)

func _on_ground_area_body_entered(_body: Node2D) -> void:
	audio_stream_player_2d.play()
	await audio_stream_player_2d.finished
	get_tree().call_deferred("change_scene_to_file", "res://scenes/levels/ground_level.tscn")

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

func _on_speed_area_body_entered(_body: Node2D) -> void:
	entered_area = $Areas/UpgradeAreas/SpeedArea

func _on_speed_area_body_exited(_body: Node2D) -> void:
	entered_area = null

func _on_duration_area_body_entered(_body: Node2D) -> void:
	entered_area = $Areas/UpgradeAreas/DurationArea

func _on_duration_area_body_exited(_body: Node2D) -> void:
	entered_area = null

func _on_quota_area_body_entered(_body: Node2D) -> void:
	print("quota")
