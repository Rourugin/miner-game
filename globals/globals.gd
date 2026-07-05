extends Node

@onready var home_spawn_marker: bool = true

var gold: float = 100.0
var reinforcements: int = 0
var zoom: Vector2 = Vector2(10.0, 10.0)
var speed: float = 100.0


var prices: Array[float] = [10.0, 10.0, 10.0, 10.0]

var blocked_cells_coordinate: Array[Vector2i] = [Vector2i(-15, -7), Vector2i(-14, -7), Vector2i(-13, -7)]
