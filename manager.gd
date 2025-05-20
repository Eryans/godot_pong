class_name Manager
extends Node

@export var player: Paddle;
@export var ai_paddle: Paddle;
@export var ball: Ball;
@export var ai_speed: float = 2;
@export var debug_mesh: MeshInstance3D
@export var is_two_player_mode: bool = false

enum BallDirection {LEFT, RIGHT}

func _physics_process(_delta: float) -> void:
	player.direction = Input.get_axis("up", "down")
	if (is_two_player_mode):
		ai_paddle.direction = Input.get_axis("ui_up", "ui_down")
	else:
		_ai_behavior()

func _ai_behavior() -> void:
	if (_get_ball_direction() == BallDirection.LEFT):
		_go_to_on_vertical_axis(0);
	else:
		_aim_to_target(Vector3(0, 0, 0))

func _go_to_on_vertical_axis(target_z: float) -> void:
	var diff = target_z - ai_paddle.global_position.z
	if abs(diff) < .1:
		# Augmenter la marge réduit la précision 
		# de la raquette quand elle vise un point précis
		# car elle ne s'arrête plus à l'endroit exact
		# pour un rebond parfait vers la cible
		ai_paddle.direction = 0
	else:
		ai_paddle.direction = sign(diff)

func _get_ball_direction() -> BallDirection:
	if (ball.direction.x < 0):
		return BallDirection.LEFT
	else:
		return BallDirection.RIGHT

func _get_intersection_point(ball_pos: Vector3, ball_dir: Vector3, paddle_x: float) -> Vector3:
	if abs(ball_dir.x) < 0.001:
		return ball_pos # trajectoire presque parallèle : renvoyer la position actuelle

	var t = (paddle_x - ball_pos.x) / ball_dir.x
	return ball_pos + ball_dir * t

func _aim_to_target(target: Vector3) -> void:
	var impact_point: Vector3 = _get_intersection_point(ball.global_position, Vector3(ball.direction.x, 0, ball.direction.y), ai_paddle.global_position.x)
	debug_mesh.global_position = impact_point

	var vector_to_target: Vector3 = target - impact_point
	var angle_to_target: float = (vector_to_target.z) / (vector_to_target.x)
	var max_angle = deg_to_rad(75)

	# Calcul inverse de l'offest (voir ball.gd) pour convertir l’angle en offset)
	var t: float = (angle_to_target + max_angle) / (2 * max_angle)
	var offset: float = t * 2 - 1

	var paddle_half_height: float = ai_paddle.get_width() / 2.0
	var target_z: float = impact_point.z + offset * paddle_half_height

	_go_to_on_vertical_axis(target_z)
