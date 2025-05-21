class_name Paddle
extends CharacterBody3D

@onready var direction: float = 0;
@onready var _paddle_mesh: MeshInstance3D = $MeshInstance3D

@export var speed: float = 2.5;
@export var tag: Enums.PlayerTagEnum;
@export_range(.1, .99) var friction: float = .9;


func get_width() -> float:
	return _paddle_mesh.get_aabb().size.z;

func _physics_process(_delta: float) -> void:
	velocity.z += direction * speed;
	velocity.z *= friction;
	move_and_slide();
