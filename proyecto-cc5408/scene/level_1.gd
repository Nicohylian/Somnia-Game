class_name Level
extends Node2D

@onready var player: Player = %Player
@onready var light: Node2D = %Light


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var shadow_direction: Vector2 = player.global_position - light.global_position
	player.direction1 = shadow_direction
