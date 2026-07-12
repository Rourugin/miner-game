extends CanvasLayer

@onready var gold_amount: Label = $GoldContainer/GoldAmount
@onready var reinforcements_amount: Label = $ReinforcementsContainer/ReinforcementsAmount
@onready var quota_amount: Label = $QuotaContainer/QuotaAmount


func _ready() -> void:
	Globals.connect("stat_change", update_ui)
	update_ui()

func update_ui() -> void:
	gold_amount.text = str(Globals.gold)
	reinforcements_amount.text = str(Globals.reinforcements)
	quota_amount.text = str(roundi(Globals.quota_timer.time_left))
