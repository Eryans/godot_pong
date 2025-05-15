class_name Paddle
extends CharacterBody3D

@onready var direction: float = 0;
@export var speed: float = 2.5;
@export_range(.1, .99) var friction: float = .9;

func get_width() -> AABB:
	return $MeshInstance3D.get_aabb();

func _physics_process(_delta: float) -> void:
	velocity.z += direction * speed;
	velocity.z *= friction;
	move_and_slide();
