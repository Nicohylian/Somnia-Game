extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_apply_effect)
	animated_sprite_2d.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _apply_effect(body: Node2D) -> void:
	if body is Player:
		var padre = get_parent()
		if padre is Level:
			padre.time_left += 1.0
			queue_free()
