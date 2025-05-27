extends Node

signal goal(player_tag: Enums.PlayerTagEnum);
signal ball_hitted_paddle(player_tag: Enums.PlayerTagEnum);
signal ball_hitted_wall();
signal button_hover();
signal button_click();

func goal_emit(player_tag: Enums.PlayerTagEnum) -> void:
    goal.emit(player_tag);

func ball_hitted_paddle_emit(player_tag: Enums.PlayerTagEnum) -> void:
    ball_hitted_paddle.emit(player_tag);

func ball_hitted_wall_emit() -> void:
    ball_hitted_wall.emit();

func button_hover_emit() -> void:
    button_hover.emit();

func button_click_emit() -> void:
    button_click.emit();

func _ready() -> void:
    goal.emit(Enums.PlayerTagEnum.NONE);