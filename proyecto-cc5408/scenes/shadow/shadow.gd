class_name Shadow
extends Node2D


@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var center: Node2D = %center

@onready var pivot: Node2D = %pivot
@onready var down_1: RayCast2D = %Down1
@onready var down_2: RayCast2D = %Down2
@onready var up_1: RayCast2D = %Up1
@onready var up_2: RayCast2D = %Up2
@onready var left_1: RayCast2D = %Left1
@onready var left_2: RayCast2D = %Left2
@onready var right_1: RayCast2D = %Right1
@onready var right_2: RayCast2D = %Right2
@onready var area_segura: Area2D = %AreaSegura

@onready var down_3: RayCast2D = %Down3

signal cant_teleport
signal can_teleport



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_segura.body_entered.connect(func(body: Node2D): cant_teleport.emit())
	area_segura.body_exited.connect(func(body: Node2D): can_teleport.emit())
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func change_animation(title: String) -> void:
	animated_sprite_2d.play(title)

func change_direction(dir: int) -> void:
	pivot.scale.x = dir
	
func move_to_point(pos: Vector2) -> void:
	center.global_position = pos
	var final = pos
	if(down_1.is_colliding() && down_2.is_colliding()):
		var algo1 = 13 - (down_3.get_collision_point().y - center.get_global_position().y )
		
		final = final + Vector2(0, -algo1)
	elif(up_1.is_colliding() && up_2.is_colliding()):
		var algo2 = 13 - (up_1.get_collision_point().y - center.get_global_position().y )
		final = final + Vector2(0, algo2)
	if(left_1.is_colliding() && left_2.is_colliding()):
		var algo3 = 8 + (left_1.get_collision_point().x - center.get_global_position().x)
		
		final = final + Vector2(algo3, 0)
	elif(right_1.is_colliding() && right_2.is_colliding()):
		var algo = 9 - (right_1.get_collision_point().x - center.get_global_position().x)
		final = final + Vector2(-algo, 0)
		
	global_position = final
	

		
	
	
	
	
