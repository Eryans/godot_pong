extends Control

@onready var text_player_A_score: RichTextLabel = %ScoreA;
@onready var text_player_B_score: RichTextLabel = %ScoreB;

func _ready() -> void:
	EventManager.connect("goal", _on_goal);


func _on_goal(goal_hit: Enums.PlayerTagEnum) -> void:
	if (goal_hit == Enums.PlayerTagEnum.A):
		GameGlobal.player_B_score += 1;
		text_player_B_score.text = str(GameGlobal.player_B_score);
	else:
		GameGlobal.player_A_score += 1;
		text_player_A_score.text = str(GameGlobal.player_A_score);
