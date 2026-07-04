extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_home_area_body_entered(_body: Node2D) -> void:
	print("Home entered")


func _on_home_area_2_body_entered(_body: Node2D) -> void:
	print("mine entered")
