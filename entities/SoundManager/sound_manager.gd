extends Node

@onready var hit_bonus_sfx: AudioStreamPlayer = %HitBonus
@onready var hit_wall_sfx: AudioStreamPlayer = %HitWall
@onready var goal_sfx: AudioStreamPlayer = %Goal
@onready var hover_sound: AudioStreamPlayer = %HoverSound;
@onready var click_sound: AudioStreamPlayer = %ClickSound;

@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	BonusManager.bonus_was_hit.connect(_on_bonus_hit)
	EventManager.ball_hitted_wall.connect(_on_ball_hit_wall)
	EventManager.goal.connect(_on_goal)
	EventManager.button_click.connect(_on_button_click)
	EventManager.button_hover.connect(_on_button_hover)

func _on_bonus_hit(_b, _c) -> void:
	hit_bonus_sfx.play();
	hit_bonus_sfx.pitch_scale = _get_random_pitch()

func _on_ball_hit_wall() -> void:
	hit_wall_sfx.play();
	hit_wall_sfx.pitch_scale = _get_random_pitch()

func _on_button_hover() -> void:
	hover_sound.play();

func _on_button_click() -> void:
	click_sound.play();

func _on_goal(_arg) -> void:
	goal_sfx.play();

func _get_random_pitch() -> float:
	return rng.randf_range(.8, 1.1)
