extends Control

@onready var text_player_A_score: RichTextLabel = %ScoreA;
@onready var text_player_B_score: RichTextLabel = %ScoreB;
@onready var new_round_timer_text: RichTextLabel = %NewRoundTimerText

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	new_round_timer_text.visible = false
	EventManager.connect("goal", _on_goal);
	GameManager.connect("new_round_timer_value_changed", _on_new_round_timer_value_changed)
	GameManager.connect("new_round_timer_timeout", _on_new_round_timer_timeout)

func _on_goal(goal_hit: Enums.PlayerTagEnum) -> void:
	if (goal_hit == Enums.PlayerTagEnum.A):
		GameGlobal.player_B_score += 1;
		text_player_B_score.text = str(GameGlobal.player_B_score);
	else:
		GameGlobal.player_A_score += 1;
		text_player_A_score.text = str(GameGlobal.player_A_score);

func _on_new_round_timer_value_changed(value: float) -> void:
	new_round_timer_text.visible = true
	new_round_timer_text.text = str(round(value)).pad_decimals(0)

func _on_new_round_timer_timeout() -> void:
	new_round_timer_text.visible = false