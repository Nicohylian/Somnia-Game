extends Area2D

func _ready() -> void:
	# Conecta señal para detectar cuerpos que entren  
	body_entered.connect(Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	# Solo daña al jugador
	if body is Player:
		body.death()
