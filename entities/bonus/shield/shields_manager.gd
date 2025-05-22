extends Node

@onready var shield_A: Shield = %Shield_A;
@onready var shield_B: Shield = %Shield_B;

func _ready() -> void:
	BonusManager.activate_shield_bonus.connect(_on_activate_shield);

func _on_activate_shield(paddle: Enums.PlayerTagEnum) -> void:
	if (paddle == Enums.PlayerTagEnum.A):
		shield_A.call_deferred("enable");
	else:
		shield_B.call_deferred("enable");
	pass
