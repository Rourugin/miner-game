extends StaticBody2D

var health: int

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var data: OreData


func _ready() -> void:
	health = data.max_health
	sprite_2d.texture = data.texture
