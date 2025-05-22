extends Node

@onready var bonus_scene: PackedScene = load("uid://drnmrkygk2jt");
@onready var _spawn_timer: Timer = Timer.new();
@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new();

signal bonus_was_hit(bonus: Bonus, paddle_who_hit: Enums.PlayerTagEnum);
signal activate_shield_bonus(paddle_to_attribuate: Enums.PlayerTagEnum)

func _ready() -> void:
	add_child(_spawn_timer);
	_spawn_timer.timeout.connect(_on_spawn_timeout);
	_spawn_timer.one_shot = true;
	_spawn_timer.start(rng.randf_range(5, 10))
	bonus_was_hit.connect(_on_bonus_hit);

func spawn() -> void:
	var scene: Bonus = bonus_scene.instantiate();
	get_tree().current_scene.add_child(scene);
	scene.global_position = Vector3(rng.randf_range(-7, 7), 0, rng.randf_range(-7, 7));

func _on_bonus_hit(_bonus: Bonus, _paddle_who_hit: Enums.PlayerTagEnum) -> void:
	activate_shield_bonus_emit(_paddle_who_hit);
	pass

func _on_spawn_timeout() -> void:
	var current_bonus: Array[Node] = get_tree().get_nodes_in_group("bonus");
	if (current_bonus.is_empty()):
		call_deferred("spawn");
	_spawn_timer.start(rng.randf_range(5, 10))

func bonus_was_hit_emit(bonus: Bonus, paddle_who_hit: Enums.PlayerTagEnum) -> void:
	bonus_was_hit.emit(bonus, paddle_who_hit);

func activate_shield_bonus_emit(paddle_to_attribuate: Enums.PlayerTagEnum) -> void:
	activate_shield_bonus.emit(paddle_to_attribuate);
