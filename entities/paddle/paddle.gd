class_name Paddle
extends CharacterBody3D

@onready var direction: float = 0;
@export var speed: float = 2.5;
@export var tag: EventManager.PlayerTagEnum;
@export_range(.1, .99) var friction: float = .9;

func get_width() -> float:
	return $MeshInstance3D.get_aabb().size.z;

func _physics_process(_delta: float) -> void:
	velocity.z += direction * speed;
	velocity.z *= friction;
	move_and_slide();
