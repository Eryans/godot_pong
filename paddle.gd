class_name Paddle
extends CharacterBody3D

@onready var direction: float = 0;
@onready var speed: float = 15;

func get_width() -> AABB:
	return $MeshInstance3D.get_aabb()

func _physics_process(_delta: float) -> void:
	velocity.z += direction * speed;
	velocity.z *= 0.85
	#friction
	move_and_slide();
