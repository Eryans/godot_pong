extends Node

@onready var bonus_scene: PackedScene = load("uid://drnmrkygk2jt")

func _ready() -> void:
	EventManager.bonus_was_hit.connect(_on_bonus_hit)
	spawn();
func spawn() -> void:
	var scene = bonus_scene.instantiate();
	get_tree().current_scene.add_child.call_deferred(scene)

func _on_bonus_hit(_bonus: Bonus, _paddle_who_hit: Enums.PlayerTagEnum) -> void:
	pass
