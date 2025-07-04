extends CharacterBody2D

var speed = 40
var direction: bool = false
var gravity = -1
@export var destiny: Vector2 = Vector2(1, 0)

@onready var raycast_front: RayCast2D = $RayCastFront
@onready var ray_cast_eye: RayCast2D = %RayCastEye


func _physics_process(delta):
	
	if !raycast_front.is_colliding():
		if direction:
			destiny = destiny.orthogonal()
		else:
			destiny = -destiny.orthogonal()
		rotation = destiny.angle()
		
		
	if ray_cast_eye.is_colliding():
		if direction:
			destiny = -destiny.orthogonal()
		else:
			destiny = destiny.orthogonal()
		rotation = destiny.angle()
		
	
	
	velocity = destiny*speed + destiny.orthogonal()*100*gravity
	move_and_slide()
	
	

	# Si no hay suelo o choca con pared, gira
	

	

func _ready():
	$AnimatedSprite2D.play("idle")
	$Area2D.body_entered.connect(_on_body_entered)
	if scale.x == -1:
		direction = true
		gravity = 1
	


func _on_body_entered(body):
	if body is Player:  # O usa el nombre de tu clase de jugador si cambiaste el class_name
		body.death()  # Llama a la función de muerte del jugador
