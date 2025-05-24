extends Area3D
class_name Bonus

@export var bonus_type: BonusManager.BonusTypeEnum
@export var mesh_list: Dictionary[StringName, Mesh] = {}

@onready var _mesh_instance: MeshInstance3D = $MeshInstance3D
var t: float = 0

func _ready() -> void:
	area_entered.connect(_on_area_entered);

func _on_area_entered(area: Area3D) -> void:
	if (area is Ball):
		BonusManager.bonus_was_hit_emit(self, area.last_hitted_paddle);
		call_deferred("queue_free");

func _physics_process(delta: float) -> void:
	t += delta
	global_position.y = .5 * sin(t * 2) + 1
	rotation.y += delta

func set_mesh_from_current_type() -> void:
	match (bonus_type):
		BonusManager.BonusTypeEnum.shield:
			_mesh_instance.mesh = mesh_list["Shield"]
		BonusManager.BonusTypeEnum.acceleration:
			_mesh_instance.mesh = mesh_list["Acceleration"]
		BonusManager.BonusTypeEnum.paddle_slow_debuff:
			_mesh_instance.mesh = mesh_list["Slow"]
		BonusManager.BonusTypeEnum.paddle_shrink_debuff:
			_mesh_instance.mesh = mesh_list["Shrink"]
		BonusManager.BonusTypeEnum.paddle_grow_buff:
			_mesh_instance.mesh = mesh_list["Grow"]
		_:
			pass