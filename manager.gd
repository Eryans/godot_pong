class_name Manager
extends Node

@export var player: Paddle;
@export var ai_paddle: Paddle;
@export var ball: Ball;
@export var ai_speed: float = 2;
@export var debug_mesh: MeshInstance3D
func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	player.direction = Input.get_axis("up", "down")
	# ai_paddle.direction = Input.get_axis("ui_up", "ui_down")
	aim_to_target(Vector3(0, 0, 0))


func get_intersection_point(ball_pos: Vector3, ball_dir: Vector3, paddle_x: float) -> Vector3:
	if abs(ball_dir.x) < 0.001:
		return ball_pos # trajectoire presque parallèle : renvoyer la position actuelle

	var t = (paddle_x - ball_pos.x) / ball_dir.x
	return ball_pos + ball_dir * t

func aim_to_target(target: Vector3) -> void:
	var paddle_x: float = ai_paddle.global_position.x

	var impact_point: Vector3 = get_intersection_point(ball.global_position, Vector3(ball.direction.x, 0, ball.direction.y), paddle_x)
	debug_mesh.global_position = impact_point

	var vector_to_bonus: Vector3 = target - impact_point
	var angle_to_bonus: float = (vector_to_bonus.z) / (vector_to_bonus.x)
	var max_angle = deg_to_rad(75)

	# Calcul inverse de l'offest (voir ball.gd) pour convertir l’angle en offset)
	var t: float = (angle_to_bonus + max_angle) / (2 * max_angle)
	var offset: float = t * 2 - 1

	var paddle_half_height: float = ai_paddle.get_width() / 2.0
	var target_z: float = impact_point.z + offset * paddle_half_height

	ai_paddle.direction = clamp(target_z - ai_paddle.global_position.z, -1, 1)