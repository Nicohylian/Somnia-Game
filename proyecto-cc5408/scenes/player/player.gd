class_name Player
extends CharacterBody2D

@onready var shadow_direction: RayCast2D = %ShadowDirection
@export var direction1: Vector2 = Vector2(1,0)
@onready var shadow: Shadow = $Shadow
@onready var pivot: Node2D = $pivot
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite: AnimatedSprite2D = $pivot/AnimatedSprite2D
@onready var teleport_timer: Timer = $Timer
@export var player_scene: PackedScene 
var teleport_particle_scene := preload("res://scenes/player/TeleportParticle.tscn")


var is_teleporting = false
const SPEED = 250.0
const JUMP_VELOCITY = -350.0

func _ready():
	is_teleporting = false  # Por seguridad

func _physics_process(delta: float) -> void:
	if is_teleporting:
		return  # Si está teletransportando, no se mueve ni hace nada más

	shadow_direction.rotation = direction1.angle()

	# GRAVEDAD
	if not is_on_floor():
		velocity += get_gravity() * delta

	# SALTO
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# TELETRANSPORTE (tecla Enter)
	if Input.is_action_just_pressed("action") and shadow_direction.is_colliding():
		is_teleporting = true
		animated_sprite.play("tp")
		teleport_timer.start()


	# MOVIMIENTO HORIZONTAL
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# Flip del sprite
	if direction != 0:
		pivot.scale.x = sign(direction)

	# ANIMACIONES
	# ANIMACIONES
	if not is_teleporting:
		if is_on_floor():
			if velocity.length() == 0:
				animated_sprite.play("idle")
			else:
				animated_sprite.play("run")

	# SOMBRA
	if shadow_direction.is_colliding():
		shadow.show()
		shadow.global_position = shadow_direction.get_collision_point()
	else:
		shadow.visible = false
		shadow.global_position = shadow_direction.target_position

func _on_timer_timeout():
	spawn_teleport_particles()
	translate((shadow.global_position - global_position) - Vector2(15, 0).rotated(direction1.angle()))
	velocity = Vector2.ZERO
	is_teleporting = false

func spawn_teleport_particles():
	var start = global_position
	var end = shadow.global_position
	var steps = 60

	for i in range(steps + 1):
		var t = i / float(steps)
		var pos = start.lerp(end, t)

		var particle = teleport_particle_scene.instantiate()
		get_tree().current_scene.add_child(particle)
		particle.global_position = pos
		particle.rotation = (end - start).angle()
