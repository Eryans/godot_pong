extends Node

@export var player: Paddle;
@export var ai_paddle: Paddle;
@export var ball: Ball;
@export var ai_speed: float = 2;

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	player.direction = Input.get_axis("up", "down")
	# ai_paddle.direction = Input.get_axis("ui_up", "ui_down")
	var ball_to_paddle_distance = clamp(ball.global_position.z - ai_paddle.global_position.z, -1, 1)
	ai_paddle.direction = ball_to_paddle_distance * ai_speed;
