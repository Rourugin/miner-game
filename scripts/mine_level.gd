extends Level

const ORE_SCENE: PackedScene = preload("res://scenes/objects/ore.tscn")
const REINFROCEMENT_SCENE: PackedScene = preload("res://scenes/objects/reinforcement.tscn")
const STAIRCASE_SCENE: PackedScene = preload("res://scenes/objects/staircase.tscn")
const EPSILON: float = 1.0
const CELL_SIZE: int = 32

@onready var player: CharacterBody2D = $Player
@onready var player_camera: Camera2D = $Player/PlayerCamera
@onready var ores: Node2D = $Ores
@onready var staircases: Node2D = $Objects/Staircases
@onready var reinforcements: Node2D = $Objects/Reinforcements
@onready var tile_map: TileMap = $TileMap
@onready var earthquake_timer: Timer = $Timers/EarthquakeTimer
@onready var hit_player: AudioStreamPlayer2D = $AudioPlayers/HitPlayer
@onready var building_player: AudioStreamPlayer2D = $AudioPlayers/BuildingPlayer
@onready var elevator_player: AudioStreamPlayer2D = $AudioPlayers/ElevatorPlayer


func _ready() -> void:
	_build_all_reinforcements()
	_generate_ores()
	_prepare()
	_create_timer()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		_break_ore()
	if Input.is_action_just_pressed("build"):
		_build_reinforcement()
	if Input.is_action_just_pressed("pause"):
		pause_game()

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

func _build_all_reinforcements() -> void:
	for i in range(Globals.blocked_cells_coordinate.size()):
		if Globals.blocked_cells_coordinate[i] == Vector2i(-15, -7):
			continue
		var reinforcement = REINFROCEMENT_SCENE.instantiate()
		var x_coords = (Globals.blocked_cells_coordinate[i].x + 0.5) * CELL_SIZE
		var y_coords = (Globals.blocked_cells_coordinate[i].y + 0.5) * CELL_SIZE
		var glob_coords = Vector2(x_coords, y_coords)
		reinforcement.global_position = glob_coords
		reinforcements.add_child(reinforcement)
		
func _is_blocked_cell(cell: Vector2i) -> bool:
	for i in range(Globals.blocked_cells_coordinate.size()):
		if cell == Globals.blocked_cells_coordinate[i]:
			return true
	
	return false

func _prepare() -> void:
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
					and (player.global_position.x + CELL_SIZE >= ores_arr[i].global_position.x)\
					and (player.global_position.y <= ores_arr[i].global_position.y)\
					and (player.global_position.y + CELL_SIZE >= ores_arr[i].global_position.y):
						_breaking(ores_arr[i])
						break
			Vector2.LEFT:
				for i in range(ores_arr.size()):
					if (player.global_position.x >= ores_arr[i].global_position.x)\
					and (player.global_position.x - CELL_SIZE <= ores_arr[i].global_position.x)\
					and (player.global_position.y <= ores_arr[i].global_position.y)\
					and (player.global_position.y + CELL_SIZE >= ores_arr[i].global_position.y):
						_breaking(ores_arr[i])
						break
			Vector2.UP:
				for i in range(ores_arr.size()):
					@warning_ignore("integer_division")
					if (abs(player.global_position.x - ores_arr[i].global_position.x) <= (CELL_SIZE / 2) + EPSILON)\
					and (ores_arr[i].global_position.y >= player.global_position.y - CELL_SIZE - EPSILON)\
					and (ores_arr[i].global_position.y <= player.global_position.y + EPSILON):
						_breaking(ores_arr[i])
						break
			Vector2.DOWN:
				for i in range(ores_arr.size()):
					@warning_ignore("integer_division")
					if (abs(player.global_position.x - ores_arr[i].global_position.x) <= (CELL_SIZE / 2) + EPSILON)\
					and (ores_arr[i].global_position.y >= player.global_position.y - EPSILON)\
					and (ores_arr[i].global_position.y <= player.global_position.y + CELL_SIZE + EPSILON):
						_breaking(ores_arr[i])
						break
	elif dir == Vector2.ZERO:
		pass

func _breaking(ore: StaticBody2D) -> void:
	player.play_animation("hit")
	hit_player.play()
	ore.health -= Globals.pickaxe_damage
	if ore.health <= 0:
		_spawn_staircase(player.last_direction)
		Globals.gold += ore.data.costs
		Globals.score += ore.data.costs * 10
		ore.queue_free()

func _get_cell_center() -> Vector2:
	var cell_x = floor(player.global_position.x / CELL_SIZE)
	var cell_y = floor(player.global_position.y / CELL_SIZE)
	return Vector2(cell_x * CELL_SIZE + CELL_SIZE / 2.0, cell_y * CELL_SIZE + CELL_SIZE / 2.0)

func _build_reinforcement() -> void:
	if Globals.reinforcements >= 0:
		var cell_center: Vector2 = _get_cell_center()
		var reinforcement = REINFROCEMENT_SCENE.instantiate()
		reinforcement.global_position = cell_center
		reinforcements.add_child(reinforcement)
		_add_blocked_cell(reinforcement)
		building_player.play()
		Globals.reinforcements -= 1

func _add_blocked_cell(object: StaticBody2D) -> void:
	var cell_coords: Vector2i = Vector2i(roundi(object.global_position.x / CELL_SIZE), roundi(object.global_position.y / CELL_SIZE))
	Globals.blocked_cells_coordinate.append(cell_coords)

func _spawn_staircase(dir: Vector2) -> void:
	if dir != Vector2.UP and dir != Vector2.DOWN:
		return
	var player_cell_center = _get_cell_center()
	var player_staircase = STAIRCASE_SCENE.instantiate()
	player_staircase.global_position = player_cell_center
	staircases.add_child(player_staircase)
	
	var next_staircase = STAIRCASE_SCENE.instantiate()
	var next_cell_center = player_cell_center
	match dir:
		Vector2.UP:
			next_cell_center.y -= CELL_SIZE
		Vector2.DOWN:
			next_cell_center.y += CELL_SIZE
		_:
			print("Can't spawn another staircase")
	next_staircase.global_position = next_cell_center
	staircases.add_child(next_staircase)
	
func _create_timer() -> void:
	var duration: float = RandomNumberGenerator.new().randf_range(180.0, 300.0) + Globals.extra_duration
	earthquake_timer.start(15)

func _on_earthquake_timer_timeout() -> void:
	Globals.game_over()

func _on_elevator_body_entered(_body: Node2D) -> void:
	elevator_player.play()
	get_tree().call_deferred("change_scene_to_file", "res://scenes/levels/ground_level.tscn")
