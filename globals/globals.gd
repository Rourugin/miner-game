extends Node

signal stat_change

@onready var home_spawn_marker: bool = true

const GAME_OVER_SCENE: PackedScene = preload("res://scenes/ui/game_over.tscn")

var gold: float = 10.0
var pickaxe_damage: int = 1
var reinforcements: int = 0
var zoom: Vector2 = Vector2(10.0, 10.0)
var extra_duration: float = 0.0
var speed: float = 100.0

var quota: float = 40.0

var score: int = 0

var prices: Array[float] = [5.0, 20.0, 15.0, 10.0, 6.7]

var blocked_cells_coordinate: Array[Vector2i] = [Vector2i(-15, -7), Vector2i(-14, -7), Vector2i(-13, -7)]

var resources: Array[OreData] = _get_resources()

var quota_timer: Timer = Timer.new()


func _ready() -> void:
	add_child(quota_timer)
	set_default()

func _process(_delta: float) -> void:
	stat_change.emit()

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

func start_quota_timer() -> void:
	quota_timer.start(267)

func game_over() -> void:
	add_child(GAME_OVER_SCENE.instantiate())

func set_default() -> void:
	gold = 10.0
	pickaxe_damage = 1
	reinforcements = 0
	zoom = Vector2(10.0, 10.0)
	extra_duration = 0.0
	speed = 100.0
	quota = 40.0
	score = 0
	prices = [5.0, 20.0, 15.0, 10.0, 6.7]
	blocked_cells_coordinate = [Vector2i(-15, -7), Vector2i(-14, -7), Vector2i(-13, -7)]
	start_quota_timer()
	
