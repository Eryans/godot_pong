extends Node

enum PlayerGoalEnum {A, B}
signal goal(player_goal: PlayerGoalEnum);

func goal_emit(player_goal: PlayerGoalEnum) -> void:
    goal.emit(player_goal)