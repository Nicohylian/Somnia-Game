class_name Level
extends Node2D

@onready var player: Player = %Player
@onready var light: Node2D = %Light

var lights: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lights = get_tree().get_nodes_in_group("Light")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var current_light: Light = null
	for light in lights:
		if current_light == null:
			current_light = light
		else:
			if (player.global_position - light.global_position).length() < (player.global_position - current_light.global_position).length():
				current_light = light
		
	var shadow_direction: Vector2 = player.global_position - current_light.global_position
	player.direction1 = shadow_direction
