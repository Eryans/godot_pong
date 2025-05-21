extends Area3D

@export var player_goal: Enums.PlayerTagEnum;

func _ready() -> void:
	area_entered.connect(on_area_entered);

func on_area_entered(area: Area3D) -> void:
	if (area is Ball):
		var ball: Ball = area;
		ball.direction.x = - ball.direction.x;
		ball.reset();
		EventManager.goal_emit(player_goal);
	pass
