extends Node

@onready var bonus_scene: PackedScene = load("uid://drnmrkygk2jt");
@onready var _spawn_timer: Timer = Timer.new();
@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new();

signal bonus_was_hit(bonus: Bonus, paddle_who_hit: Enums.PlayerTagEnum);
signal activate_shield_bonus(paddle_to_attribuate: Enums.PlayerTagEnum)
signal activate_acceleration_bonus(paddle_to_attribuate: Enums.PlayerTagEnum)
signal activate_slow_debuff_bonus(paddle_to_attribuate: Enums.PlayerTagEnum)
signal activate_shrink_debuff_bonus(paddle_to_attribuate: Enums.PlayerTagEnum)
signal activate_grow_buff_bonus(paddle_to_attribuate: Enums.PlayerTagEnum)

enum BonusTypeEnum {
	shield,
	acceleration,
	paddle_slow_debuff,
	paddle_shrink_debuff,
	paddle_grow_buff
}

func _ready() -> void:
	add_child(_spawn_timer);
	_spawn_timer.timeout.connect(_on_spawn_timeout);
	_spawn_timer.one_shot = true;
	_spawn_timer.start(rng.randf_range(5, 10))
	bonus_was_hit.connect(_on_bonus_hit);
	EventManager.goal.connect(_on_goal);
	GameManager.new_round_timer_timeout.connect(_on_new_round_timer_timeout);


func spawn() -> void:
	var new_bonus: Bonus = bonus_scene.instantiate();
	get_tree().current_scene.add_child(new_bonus);
	new_bonus.bonus_type = randi_range(0, BonusTypeEnum.size() - 1) as BonusTypeEnum
	new_bonus.set_mesh_from_current_type();
	new_bonus.global_position = Vector3(rng.randf_range(-7, 7), 0, rng.randf_range(-7, 7));

func _on_bonus_hit(bonus: Bonus, _paddle_who_hit: Enums.PlayerTagEnum) -> void:
	match (bonus.bonus_type):
		BonusTypeEnum.shield:
			activate_shield_bonus.emit(_paddle_who_hit);
		BonusTypeEnum.acceleration:
			activate_acceleration_bonus.emit(_paddle_who_hit);
		BonusTypeEnum.paddle_slow_debuff:
			activate_slow_debuff_bonus.emit(_paddle_who_hit);
		BonusTypeEnum.paddle_shrink_debuff:
			activate_shrink_debuff_bonus.emit(_paddle_who_hit);
		BonusTypeEnum.paddle_grow_buff:
			activate_grow_buff_bonus.emit(_paddle_who_hit);
		_:
			pass

func _on_spawn_timeout() -> void:
	var current_bonus: Array[Node] = get_tree().get_nodes_in_group("bonus");
	if (current_bonus.is_empty()):
		call_deferred("spawn");
	_spawn_timer.start(rng.randf_range(5, 10))

func bonus_was_hit_emit(bonus: Bonus, paddle_who_hit: Enums.PlayerTagEnum) -> void:
	bonus_was_hit.emit(bonus, paddle_who_hit);

func _on_goal(_player) -> void:
	_spawn_timer.paused = true

func _on_new_round_timer_timeout() -> void:
	_spawn_timer.paused = false