extends Node3D
class_name Reactor

@onready var _particles: GPUParticles3D = $GPUParticles3D
@onready var particles_amount_lerp_weight: int = 0


func _physics_process(_delta: float) -> void:
    _particles.amount = lerp(2, 120, particles_amount_lerp_weight);
    _particles.emitting = (_particles.amount > 2);
