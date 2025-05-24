extends Area3D
class_name Wall

@export var show_mesh: bool = true;

@onready var _mesh_instance: MeshInstance3D = $MeshInstance3D

func _ready() -> void:
	_mesh_instance.visible = show_mesh;
