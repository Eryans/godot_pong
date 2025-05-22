extends Node

@onready var _new_round_timer: Timer = Timer.new();

signal new_round_timer_value_changed(value: float);
signal new_round_timer_timeout();

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS;
	add_child(_new_round_timer);
	_new_round_timer.timeout.connect(_on_new_round_timeout)
	_new_round_timer.one_shot = true;
	EventManager.goal.connect(_on_goal);

func _on_goal(_player_tag: Enums.PlayerTagEnum) -> void:
	_new_round_timer.start(3)
	get_tree().paused = true;

func _on_new_round_timeout() -> void:
	get_tree().paused = false;
	new_round_timer_timeout.emit()

func _process(_delta):
	if (_new_round_timer.time_left > 0):
		new_round_timer_value_changed.emit(_new_round_timer.time_left)