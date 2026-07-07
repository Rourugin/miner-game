extends StaticBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var health: int
@export var data: OreData


func _ready() -> void:
	health = data.max_health
	sprite_2d.texture = data.texture
