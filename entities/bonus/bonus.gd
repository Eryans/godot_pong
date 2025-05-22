extends Area3D
class_name Bonus

@export var bonus_type: BonusManager.BonusTypeEnum

func _ready() -> void:
	area_entered.connect(_on_area_entered);

func _on_area_entered(area: Area3D) -> void:
	if (area is Ball):
		BonusManager.bonus_was_hit_emit(self, area.last_hitted_paddle);
		call_deferred("queue_free");
