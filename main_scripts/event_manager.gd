extends Node

signal goal(player_tag: Enums.PlayerTagEnum);
signal ball_hitted_paddle(player_tag: Enums.PlayerTagEnum);


func goal_emit(player_tag: Enums.PlayerTagEnum) -> void:
    goal.emit(player_tag)

func ball_hitted_paddle_emit(player_tag: Enums.PlayerTagEnum) -> void:
    ball_hitted_paddle.emit(player_tag);

func _ready() -> void:
    goal.emit(Enums.PlayerTagEnum.NONE)
    print("emit empty goal")