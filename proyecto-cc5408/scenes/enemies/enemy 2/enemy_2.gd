extends CharacterBody2D

var speed = 50
var direction = -1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var raycast: RayCast2D = $RayCastFront


func _physics_process(delta):
	velocity.y += gravity * delta
	velocity.x = speed * direction
	move_and_slide()
	
	# Actualiza la dirección del RayCast
	raycast.position.x = 16 * direction # Ajusta 16 según el tamaño del sprite

	# Si no hay suelo o choca con pared, gira
	if not raycast.is_colliding() or is_on_wall():
		direction *= -1

	$AnimatedSprite2D.flip_h = direction < 0

func _ready():
	$AnimatedSprite2D.play("idle")
	$Area2D.body_entered.connect(_on_body_entered)


func _on_body_entered(body):
	if body is Player:  # O usa el nombre de tu clase de jugador si cambiaste el class_name
		body.death()  # Llama a la función de muerte del jugador
