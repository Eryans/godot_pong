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

	var bonus_position = Vector3(0, 0, 5) # position du bonus
	var paddle_x = ai_paddle.global_position.x

	# 1. Prédire le point d’impact sur l’axe vertical du paddle
	var impact_point = get_intersection_point(ball.global_position, Vector3(ball.direction.x, 0, ball.direction.y), paddle_x)
	debug_mesh.global_position = impact_point

	# 2. Vecteur du point d’impact vers le bonus
	var vector_to_bonus = bonus_position - impact_point
	var angle_to_bonus = (vector_to_bonus.z) / (vector_to_bonus.x)
	# 3. Clamp l’angle pour rester dans les limites du paddle
	var max_angle = deg_to_rad(75)
	# angle_to_bonus = clamp(angle_to_bonus, -max_angle, max_angle)
	print(rad_to_deg(angle_to_bonus))
	# 4. Convertir l’angle en offset (dans l’intervalle [-1, 1])
	var t = (angle_to_bonus + max_angle) / (2 * max_angle)
	var offset = t * 2 - 1

	# 5. Appliquer cet offset sur le point d’impact
	var paddle_half_height = ai_paddle.get_width() / 2.0
	var target_z = impact_point.z + offset * paddle_half_height

	# 6. Déplacer le paddle vers cette position cible
	ai_paddle.direction = sign(target_z - ai_paddle.global_position.z)


func get_intersection_point(ball_pos: Vector3, ball_dir: Vector3, paddle_x: float) -> Vector3:
	if abs(ball_dir.x) < 0.001:
		return ball_pos # trajectoire presque parallèle : renvoyer la position actuelle

	var t = (paddle_x - ball_pos.x) / ball_dir.x
	return ball_pos + ball_dir * t
