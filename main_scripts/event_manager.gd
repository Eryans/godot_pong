extends Node

signal goal(player_tag: Enums.PlayerTagEnum);
signal ball_hitted_paddle(player_tag: Enums.PlayerTagEnum);
signal bonus_was_hit(bonus: Bonus, paddle_who_hit: Enums.PlayerTagEnum);
signal activate_shield_bonus(paddle_to_attribuate: Enums.PlayerTagEnum)

func goal_emit(player_tag: Enums.PlayerTagEnum) -> void:
    goal.emit(player_tag)

func ball_hitted_paddle_emit(player_tag: Enums.PlayerTagEnum) -> void:
    ball_hitted_paddle.emit(player_tag);

func bonus_was_hit_emit(bonus: Bonus, paddle_who_hit: Enums.PlayerTagEnum) -> void:
    bonus_was_hit.emit(bonus, paddle_who_hit);

func activate_shield_bonus_emit(paddle_to_attribuate: Enums.PlayerTagEnum) -> void:
    activate_shield_bonus.emit(paddle_to_attribuate);