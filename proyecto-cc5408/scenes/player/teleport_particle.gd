extends Node2D

func _ready():
	$GPUParticles2D.restart()
	await get_tree().create_timer(1).timeout
	queue_free()
