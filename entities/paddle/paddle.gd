class_name Paddle
extends CharacterBody3D

@onready var direction: float = 0;
@onready var _paddle_mesh: MeshInstance3D = $MeshInstance3D
@onready var _paddle_collider: CollisionShape3D = $CollisionShape3D
@onready var _paddle_border_decoration_neg = %PaddleBorderDecorationNeg
@onready var _paddle_border_decoration_pos = %PaddleBorderDecorationPos
@onready var _slow_timer: Timer = Timer.new()
@onready var _shrink_timer: Timer = Timer.new()
@onready var _grow_timer: Timer = Timer.new()

@export var speed: float = 2.5;
@export var tag: Enums.PlayerTagEnum;
@export var bonus_time: float = 8
@export_range(.1, .99) var friction: float = .9;

var _friction_tmp_save: float = 0;
var _paddle_original_size: Vector3 = Vector3(.25, 1, 3.5);

func _ready() -> void:
	BonusManager.activate_slow_debuff_bonus.connect(_on_slow_debuff)
	BonusManager.activate_shrink_debuff_bonus.connect(_on_shrink_debuff)
	BonusManager.activate_grow_buff_bonus.connect(_on_grow_buff)
	add_child(_slow_timer)
	add_child(_shrink_timer)
	add_child(_grow_timer)
	_slow_timer.timeout.connect(_on_slow_timeout)
	_shrink_timer.timeout.connect(_on_shrink_timeout)
	_grow_timer.timeout.connect(_on_grow_timeout)
	_slow_timer.one_shot = true;
	_shrink_timer.one_shot = true;
	_grow_timer.one_shot = true;

func get_width() -> float:
	return _paddle_mesh.get_aabb().size.z;

func _physics_process(_delta: float) -> void:
	var paddle_decoration_half_width = .124 # size is reduced a tiny bit to hide clipping
	_paddle_border_decoration_neg.position.z = - get_width() / 2 + paddle_decoration_half_width
	_paddle_border_decoration_pos.position.z = get_width() / 2 - paddle_decoration_half_width
	velocity.z += direction * speed;
	velocity.z *= friction;
	move_and_slide();

func _on_slow_debuff(p_tag: Enums.PlayerTagEnum) -> void:
	if (tag == p_tag):
		_friction_tmp_save = friction;
		friction = .75;
		_slow_timer.start(bonus_time);

func _on_shrink_debuff(p_tag: Enums.PlayerTagEnum) -> void:
	if (tag == p_tag):
		_change_paddle_vertical_size(2)
		_shrink_timer.start(bonus_time);

func _on_grow_buff(p_tag: Enums.PlayerTagEnum) -> void:
	if (tag == p_tag):
		_change_paddle_vertical_size(5)
		_grow_timer.start(bonus_time);

func _on_slow_timeout() -> void:
	friction = _friction_tmp_save

func _on_shrink_timeout() -> void:
	reset_size()

func _on_grow_timeout() -> void:
	reset_size()

func _change_paddle_vertical_size(size: float) -> void:
	_paddle_mesh.mesh.size = Vector3(_paddle_original_size.x, _paddle_original_size.y, size)
	_paddle_collider.shape.size = Vector3(_paddle_original_size.x, _paddle_original_size.y, size)

func reset_size() -> void:
	_paddle_mesh.mesh.size = _paddle_original_size
	_paddle_collider.shape.size = _paddle_original_size
