class_name ball
extends Area3D

@export var speed: float = 10.0;
var direction: Vector2 = Vector2.LEFT;
var rdm: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	direction.y = rdm.randf_range(-.5, .5);
	body_entered.connect(on_body_entered);

func _physics_process(delta: float) -> void:
	global_position += Vector3(direction.x, global_position.y, direction.y) * speed * delta;

func on_body_entered(body: Node3D) -> void:
	if (body is CSGBox3D):
		direction.y = - direction.y;
	if (body is Paddle):
		var paddle: Paddle = body
		var max_angle = deg_to_rad(75);
		var offset = (global_position.z - paddle.position.z) / (paddle.get_width().size.z / 2);
		offset = clamp(offset, -1, 1); # On limite les débordements

		var angle = lerp(-max_angle, max_angle, (offset + 1) / 2);
		print()
		direction = Vector2(cos(angle) * (1 if global_position.x - paddle.position.x > 0 else -1), sin(angle)).normalized();
