extends Area2D


func _ready() -> void:
	# Conecta el signal body_entered usando Callable (Godot 4)
	self.body_entered.connect(Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	# Si el que entra es el jugador, dispara su método death()
	if body is Player:
		body.death()
