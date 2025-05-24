extends Node3D
class_name Reactor

@onready var _particles: GPUParticles3D = $GPUParticles3D
@onready var particles_amount_lerp_weight: float = 30
var activated: bool = false;

func _physics_process(delta: float) -> void:
	var target: int = 120 if activated else 2
	_particles.amount = lerp(_particles.amount, target, particles_amount_lerp_weight * delta);
	_particles.emitting = (_particles.amount > 2);
