extends Node

@export var player: Paddle;
@export var ai_paddle: Paddle;

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	player.direction = Input.get_axis("up", "down")
	ai_paddle.direction = Input.get_axis("ui_up", "ui_down")
