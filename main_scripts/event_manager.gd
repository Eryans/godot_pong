extends Node

enum PlayerTagEnum {A, B}

signal goal(player_tag: PlayerTagEnum);
signal ball_hitted_paddle(player_tag: PlayerTagEnum);

func goal_emit(player_tag: PlayerTagEnum) -> void:
    goal.emit(player_tag)

func ball_hitted_paddle_emit(player_tag: PlayerTagEnum) -> void:
    ball_hitted_paddle.emit(player_tag);