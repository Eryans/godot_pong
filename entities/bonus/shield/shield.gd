extends StaticBody3D
class_name Shield

@export var shield_activation_life_time: float = 10.0

@onready var _collider: CollisionShape3D = $CollisionShape3D
@onready var _life_timer: Timer = Timer.new()

func _ready() -> void:
    disable();
    add_child(_life_timer);
    _life_timer.timeout.connect(_on_timeout)
    _life_timer.one_shot = true;

func disable() -> void:
    _collider.disabled = true
    visible = false;

func enable() -> void:
    _collider.disabled = false
    visible = true;
    _life_timer.start(shield_activation_life_time);

func _on_timeout() -> void:
    disable();