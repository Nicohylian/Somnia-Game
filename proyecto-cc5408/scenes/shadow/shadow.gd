class_name Shadow
extends Node2D


@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var pivot: Node2D = %pivot



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func change_animation(title: String) -> void:
	animated_sprite_2d.play(title)

func change_direction(dir: int) -> void:
	pivot.scale.x = dir
	
	
