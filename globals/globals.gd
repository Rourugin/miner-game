extends Node

@onready var home_spawn_marker: bool = true

var gold: float = 100.0
var pickaxe_damage: int = 1
var reinforcements: int = 3
var zoom: Vector2 = Vector2(10.0, 10.0)
var extra_duration: float = 0.0
var speed: float = 100.0


var prices: Array[float] = [10.0, 10.0, 10.0, 10.0, 10.0]

var blocked_cells_coordinate: Array[Vector2i] = [Vector2i(-15, -7), Vector2i(-14, -7), Vector2i(-13, -7)]

var resources: Array[OreData] = _get_resources()

func _get_resources() -> Array[OreData]:
	var dir_path := "res://data"
	var dir := DirAccess.open(dir_path)
	var files := dir.get_files()
	
	var resources_arr: Array[OreData] = []
	var res: Array[OreData] = []
	for file in files:
		resources_arr.append(load(dir_path + '/' + file))
		res.append(load(dir_path + '/' + file))
	
	for resource in res:
		for i in range(resource.rarity):
			resources_arr.append(resource)
	return resources_arr
