extends Area3D
class_name Bonus

enum BonusTypeEnum {
    shield,
    acceleration
}

@export var bonus_type: BonusTypeEnum = BonusTypeEnum.shield

func _ready() -> void:
    area_entered.connect(_on_area_entered);

func _on_area_entered(area: Area3D) -> void:
    if (area is Ball):
        EventManager.bonus_was_hit_emit(self, area.last_hitted_paddle)