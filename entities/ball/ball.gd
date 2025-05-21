class_name Ball
extends Area3D

@export var base_speed: float = 10.0;
@export var bounce_speed_increase: float = .5;
@onready var speed: float = base_speed;

var direction: Vector2 = Vector2.LEFT;
var rdm: RandomNumberGenerator = RandomNumberGenerator.new()
var last_hitted_paddle: EventManager.PlayerTagEnum = EventManager.PlayerTagEnum.A;

func _ready() -> void:
	direction.y = rdm.randf_range(-.5, .5);
	body_entered.connect(on_body_entered);

func _physics_process(delta: float) -> void:
	global_position += Vector3(direction.x, global_position.y, direction.y) * speed * delta;

func on_body_entered(body: Node3D) -> void:
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
