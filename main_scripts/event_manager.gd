extends Node

enum PlayerTagEnum {A, B}

signal goal(player_tag: PlayerTagEnum);
signal ball_hitted_paddle(player_tag: PlayerTagEnum);
signal bonus_was_hit(bonus: Bonus, paddle_who_hit: EventManager.PlayerTagEnum);
signal activate_shield_bonus(paddle_to_attribuate: EventManager.PlayerTagEnum)

func goal_emit(player_tag: PlayerTagEnum) -> void:
    goal.emit(player_tag)

func ball_hitted_paddle_emit(player_tag: PlayerTagEnum) -> void:
    ball_hitted_paddle.emit(player_tag);

func bonus_was_hit_emit(bonus: Bonus, paddle_who_hit: EventManager.PlayerTagEnum) -> void:
    bonus_was_hit.emit(bonus, paddle_who_hit);

func activate_shield_bonus_emit(paddle_to_attribuate: EventManager.PlayerTagEnum) -> void:
    activate_shield_bonus.emit(paddle_to_attribuate);