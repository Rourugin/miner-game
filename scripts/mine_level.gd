extends Node2D

const ORE_SCENE: PackedScene = preload("res://scenes/objects/ore.tscn")

@onready var player: CharacterBody2D = $Player
@onready var player_camera: Camera2D = $Player/PlayerCamera
@onready var ores: Node2D = $Ores
@onready var tile_map: TileMap = $TileMap


func _ready() -> void:
	_generate_ores()
	_ready_player()

func _on_area_2d_body_entered(_body: Node2D) -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/levels/ground_level.tscn")

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
	var resources = _get_resources()
	
	for i in range(available_cells.size()):
		var cell: Vector2i = available_cells[i]
		var ore := ORE_SCENE.instantiate()

		#-7 is 0 depth
		var available_resources: Array[OreData]
		for resource in resources:
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

func _get_resources() -> Array[OreData]:
	var dir_path := "res://data"
	var dir := DirAccess.open(dir_path)
	var files := dir.get_files()
	
	var resources: Array[OreData] = []
	for file in files:
		resources.append(load(dir_path + '/' + file))
		
	print(resources[0])
	return resources
