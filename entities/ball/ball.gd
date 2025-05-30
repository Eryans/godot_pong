class_name Ball
extends Area3D

@export var base_speed: float = 10.0;
@export var bounce_speed_increase: float = .5;
@export var _maximum_speed: float = 35.0

@onready var speed: float = 0;
@onready var _acceleration_bonus_timer: Timer = Timer.new()

@onready var hit_paddle_sfx: AudioStreamPlayer = %HitPaddle

var current_speed_save: float;
var direction: Vector2 = Vector2.LEFT;
var rdm: RandomNumberGenerator = RandomNumberGenerator.new()
var last_hitted_paddle: Enums.PlayerTagEnum;

func _ready() -> void:
	direction.y = rdm.randf_range(-.5, .5);
	body_entered.connect(on_body_entered);
	area_entered.connect(on_area_entered);
	add_child(_acceleration_bonus_timer);
	_acceleration_bonus_timer.one_shot = true;
	_acceleration_bonus_timer.timeout.connect(_on_acceleration_timer_timeout)
	BonusManager.activate_acceleration_bonus.connect(_on_acceleration_bonus)
	EventManager.goal.connect(_on_goal);
	GameManager.new_round_timer_timeout.connect(_on_new_round_timer_timeout);


func _physics_process(delta: float) -> void:
	global_position += Vector3(direction.x, global_position.y, direction.y) * speed * delta;

func on_area_entered(area: Area3D) -> void:
	if (area.is_in_group("wall")):
		direction.y = - direction.y;
		EventManager.ball_hitted_wall_emit();

func on_body_entered(body: Node3D) -> void:
	if (speed < _maximum_speed):
		speed += bounce_speed_increase;
	if (body is StaticBody3D):
		direction.x = - direction.x;
	if (body is Paddle):
		hit_paddle_sfx.play();
		var paddle: Paddle = body
		last_hitted_paddle = paddle.tag;
		var max_angle = deg_to_rad(75);
		var offset = (global_position.z - paddle.position.z) / (paddle.get_width() / 2);
		offset = clamp(offset, -1, 1);
		var angle = lerp(-max_angle, max_angle, (offset + 1) / 2);
		direction = Vector2(cos(angle) * (1 if global_position.x - paddle.position.x > 0 else -1), sin(angle)).normalized();
		EventManager.ball_hitted_paddle_emit(paddle.tag);

func reset() -> void:
	global_position = Vector3.ZERO;

func _on_acceleration_bonus(_paddle_who_hit: Enums.PlayerTagEnum) -> void:
	current_speed_save = speed;
	speed += 10
	_acceleration_bonus_timer.start(4)
	pass

func _on_acceleration_timer_timeout() -> void:
	speed = current_speed_save

func _on_goal(_player: Enums.PlayerTagEnum) -> void:
	speed = 0;
	direction.y = rdm.randf_range(-1, 1)
	direction.x = 1 if _player == Enums.PlayerTagEnum.A else -1
	direction = direction.normalized()
func _on_new_round_timer_timeout() -> void:
	speed = base_speed