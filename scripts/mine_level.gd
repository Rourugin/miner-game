extends Node2D

const ORE_SCENE: PackedScene = preload("res://scenes/objects/ore.tscn")

@onready var player: CharacterBody2D = $Player
@onready var player_camera: Camera2D = $Player/PlayerCamera
@onready var ores: Node2D = $Ores
@onready var tile_map: TileMap = $TileMap
@onready var earthquake_timer: Timer = $Timers/EarthquakeTimer


func _ready() -> void:
	_generate_ores()
	_ready_player()
	_create_timer()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		_break_ore()

func _generate_ores() -> void:
	for ore in ores.get_children():
		ore.queue_free()
	var mine_cells: Array[Vector2i] = tile_map.get_used_cells(0)
	var available_cells: Array[Vector2i] = []
	
	for cell in mine_cells:
		if _is_blocked_cell(cell):
			continue
		var tile_data = tile_map.get_cell_tile_data(0, cell)
		if tile_data and tile_data.get_custom_data("can_spawn_ores") == true:
			available_cells.append(cell)
	
	available_cells.shuffle()
	
	
	for i in range(available_cells.size()):
		var cell: Vector2i = available_cells[i]
		var ore := ORE_SCENE.instantiate()

		var available_resources: Array[OreData]
		for resource in Globals.resources:
			if resource.min_depth <= (cell.y + 7):
				available_resources.append(resource)
		
		var random_ore_data = available_resources.pick_random()
		ore.data = random_ore_data
		var local_position: Vector2 = tile_map.map_to_local(cell)
		ore.global_position = local_position
		ores.add_child(ore)

func _is_blocked_cell(cell: Vector2i) -> bool:
	for i in range(Globals.blocked_cells_coordinate.size()):
		if cell == Globals.blocked_cells_coordinate[i]:
			return true
	
	return false

func _ready_player() -> void:
	player_camera.limit_left = -10000
	player_camera.limit_right = 10000
	player_camera.zoom = Globals.zoom
	player.global_position = $Markers/SpawnMarker.global_position
	Globals.home_spawn_marker = false

func _break_ore() -> void:
	var dir: Vector2 = player.last_direction
	if dir != Vector2.ZERO:
		var ores_arr: Array[Node] = ores.get_children()
		match dir:
			Vector2.RIGHT:
				for i in range(ores_arr.size()):
					if (player.global_position.x <= ores_arr[i].global_position.x)\
					and (player.global_position.x + 32 >= ores_arr[i].global_position.x)\
					and (player.global_position.y <= ores_arr[i].global_position.y)\
					and (player.global_position.y + 32 >= ores_arr[i].global_position.y):
						_breaking(ores_arr[i])
						break
			Vector2.LEFT:
				for i in range(ores_arr.size()):
					if (player.global_position.x >= ores_arr[i].global_position.x)\
					and (player.global_position.x - 32 <= ores_arr[i].global_position.x)\
					and (player.global_position.y <= ores_arr[i].global_position.y)\
					and (player.global_position.y + 32 >= ores_arr[i].global_position.y):
						_breaking(ores_arr[i])
						break
			Vector2.UP:
				for i in range(ores_arr.size()):
					if (player.global_position.x - 31 <= ores_arr[i].global_position.x)\
					and (player.global_position.x + 31 >= ores_arr[i].global_position.x)\
					and (player.global_position.y <= ores_arr[i].global_position.y)\
					and (player.global_position.y - 32 >= ores_arr[i].global_position.y):
						_breaking(ores_arr[i])
						break
			Vector2.DOWN:
				for i in range(ores_arr.size()):
					if (player.global_position.x <= ores_arr[i].global_position.x)\
					and (player.global_position.x + 32 >= ores_arr[i].global_position.x)\
					and (player.global_position.y <= ores_arr[i].global_position.y)\
					and (player.global_position.y + 32 >= ores_arr[i].global_position.y):
						print("he")
						_breaking(ores_arr[i])
						break
	elif dir == Vector2.ZERO:
		pass

func _breaking(ore: StaticBody2D) -> void:
	ore.health -= Globals.pickaxe_damage
	if ore.health <= 0:
		Globals.gold += ore.data.costs
		ore.queue_free()

func _create_timer() -> void:
	var duration: float = RandomNumberGenerator.new().randf_range(180.0, 300.0) + Globals.extra_duration
	earthquake_timer.start(duration)

func _on_earthquake_timer_timeout() -> void:
	print("you lost")


func _on_elevator_body_entered(_body: Node2D) -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/levels/ground_level.tscn")
