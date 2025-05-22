class_name Ball
extends Area3D

@export var base_speed: float = 10.0;
@export var bounce_speed_increase: float = .5;

@onready var speed: float = base_speed;
@onready var _acceleration_bonus_timer: Timer = Timer.new()

var current_speed_save: float;
var direction: Vector2 = Vector2.LEFT;
var rdm: RandomNumberGenerator = RandomNumberGenerator.new()
var last_hitted_paddle: Enums.PlayerTagEnum;
var _maximum_speed: float = 25.0

func _ready() -> void:
	direction.y = rdm.randf_range(-.5, .5);
	body_entered.connect(on_body_entered);
	add_child(_acceleration_bonus_timer);
	_acceleration_bonus_timer.one_shot = true;
	_acceleration_bonus_timer.timeout.connect(_on_acceleration_timer_timeout)
	BonusManager.activate_acceleration_bonus.connect(_on_acceleration_bonus)

func _physics_process(delta: float) -> void:
	global_position += Vector3(direction.x, global_position.y, direction.y) * speed * delta;

func on_body_entered(body: Node3D) -> void:
	if (speed < _maximum_speed):
		speed += bounce_speed_increase;
	if (body is CSGBox3D):
		direction.y = - direction.y;
	if (body is StaticBody3D):
		direction.x = - direction.x
	if (body is Paddle):
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
	speed = base_speed;

func _on_acceleration_bonus(_paddle_who_hit: Enums.PlayerTagEnum) -> void:
	current_speed_save = speed;
	speed += 10
	_acceleration_bonus_timer.start(4)
	pass

func _on_acceleration_timer_timeout() -> void:
	speed = current_speed_save