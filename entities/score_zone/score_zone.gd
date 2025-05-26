extends Area3D

@export var player_goal: Enums.PlayerTagEnum;

@onready var goal_explosion: Node3D = %GoalExplosion
@onready var goal_explosion_animation_player: AnimationPlayer = goal_explosion.get_child(0)

func _ready() -> void:
	area_entered.connect(on_area_entered);

func on_area_entered(area: Area3D) -> void:
	if (area is Ball):
		var ball: Ball = area;
		goal_explosion.global_position.z = ball.global_position.z
		ball.reset();
		goal_explosion_animation_player.play("goal_explosion");
		EventManager.goal_emit(player_goal);
	pass
