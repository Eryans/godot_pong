class_name AI
extends Node

@export var player_paddle: Paddle;
@export var ai_paddle: Paddle;
@export var ball: Ball;
@export var debug_mesh: MeshInstance3D
@export var is_two_player_mode: bool = false
@export var _ai_precision_margin: float = .1
@export_range(.1, 1) var _ai_speed: float = .9;
@export_range(.1, 1) var ai_max_think_time: float = .75;

@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new();
@onready var _target: Vector3 = Vector3.ZERO;
@onready var _target_vertical: float = 0;
@onready var _think_timer: Timer = Timer.new();

var _arena_half_width: int = 8 # Should not change i guess
var _ai_can_move = false;

func _ready() -> void:
	EventManager.ball_hitted_paddle.connect(_on_ball_hitted_paddle)
	add_child(_think_timer);
	EventManager.connect("goal", _on_goal);
	_think_timer.one_shot = true
	_think_timer.connect("timeout", _on_think_timer_timeout);

func _physics_process(_delta: float) -> void:
	#TODO : Refactor this bit to have a better separation of responsability
	player_paddle.direction = Input.get_axis("up", "down")
	if (is_two_player_mode):
		ai_paddle.direction = Input.get_axis("ui_up", "ui_down")
	else:
		_ai_behavior()

func _ai_behavior() -> void:
	if (_get_ball_direction() == Enums.BallDirection.LEFT):
		_go_to_on_vertical_axis(_target_vertical);
	else:
		if (_ai_can_move):
			_aim_to_target(_target);

func choose_ai_wait_target() -> void:
	var rdm_int: int = rng.randi_range(1, 4);
	match (rdm_int):
		2:
			_target_vertical = (float(_arena_half_width) / 2);
		3:
			_target_vertical = - (float(_arena_half_width) / 2);
		4:
			_target_vertical = rng.randi_range(-_arena_half_width, _arena_half_width)
		_, 1:
			_target_vertical = 0;


func choose_ai_attack_target() -> void:
	var rdm_int: int = rng.randi_range(1, 3);
	var player_paddle_vector = Vector3(player_paddle.global_position.x, 0, 0)
	match (rdm_int):
		2: # random attack
			_target = player_paddle_vector + Vector3(0, 0, 1) * rng.randi_range(-_arena_half_width, _arena_half_width);
		3: # Aim for player contrary point
			_target = player_paddle_vector + Vector3(0, 0, 1) * (-_arena_half_width if player_paddle.global_position.z > 0 else _arena_half_width);
		_, 1: # aim for center or bonus
			_target = Vector3.ZERO;
			var current_bonus: Array[Node] = get_tree().get_nodes_in_group("bonus");
			if (!current_bonus.is_empty()):
				_target = (current_bonus[0] as Bonus).global_position;
	debug_mesh.global_position = _target

func _go_to_on_vertical_axis(target_z: float) -> void:
	var diff = target_z - ai_paddle.global_position.z
	if abs(diff) < _ai_precision_margin:
		# Augmenter la marge réduit la précision 
		# de la raquette quand elle vise un point précis
		# car elle ne s'arrête plus à l'endroit exact
		# pour un rebond parfait vers la cible
		ai_paddle.direction = 0
	else:
		ai_paddle.direction = sign(diff) * _ai_speed

func _get_ball_direction() -> Enums.BallDirection:
	if (ball.direction.x < 0):
		return Enums.BallDirection.LEFT
	else:
		return Enums.BallDirection.RIGHT

func _get_intersection_point(ball_pos: Vector3, ball_dir: Vector3, paddle_x: float) -> Vector3:
	if abs(ball_dir.x) < 0.001:
		return ball_pos # trajectoire presque parallèle : renvoyer la position actuelle

	var t = (paddle_x - ball_pos.x) / ball_dir.x
	return ball_pos + ball_dir * t

func _aim_to_target(target: Vector3) -> void:
	var impact_point: Vector3 = _get_intersection_point(ball.global_position, Vector3(ball.direction.x, 0, ball.direction.y), ai_paddle.global_position.x)

	var vector_to_target: Vector3 = target - impact_point
	var angle_to_target: float = (vector_to_target.z) / (vector_to_target.x)
	var max_angle = deg_to_rad(75)

	# Calcul inverse de l'offest (voir ball.gd) pour convertir l’angle en offset)
	var t: float = (angle_to_target + max_angle) / (2 * max_angle)
	var offset: float = t * 2 - 1

	var paddle_half_height: float = ai_paddle.get_width() / 2.0
	var target_z: float = impact_point.z + offset * paddle_half_height

	_go_to_on_vertical_axis(target_z)

func _on_goal(_player_tag: Enums.PlayerTagEnum) -> void:
	_ai_can_move = true;

func _on_think_timer_timeout() -> void:
	_ai_can_move = true;
	choose_ai_attack_target();

func _on_ball_hitted_paddle(player_tag: Enums.PlayerTagEnum) -> void:
	if (player_tag == Enums.PlayerTagEnum.B):
		choose_ai_wait_target();
		_ai_can_move = false;
	else:
		# TODO : Fix timer preventing AI to act after scoring because it waits for the ball to bounce off the player
		_think_timer.start(rng.randf_range(.1, ai_max_think_time))
