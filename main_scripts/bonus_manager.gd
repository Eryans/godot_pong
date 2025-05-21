extends Node

@onready var bonus_scene: PackedScene = load("uid://drnmrkygk2jt")

func _ready() -> void:
    spawn();
func spawn() -> void:
    var scene = bonus_scene.instantiate();
    get_tree().current_scene.add_child.call_deferred(scene)