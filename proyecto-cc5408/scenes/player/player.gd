class_name Player
extends CharacterBody2D

@onready var shadow_direction: RayCast2D = %ShadowDirection
@onready var shadow: Shadow = $Shadow
@onready var pivot: Node2D = $pivot
@onready var animated_sprite: AnimatedSprite2D = $pivot/AnimatedSprite2D
@onready var teleport_timer: Timer = $Timer
@onready var tp_cooldown_timer: Timer = $TeleportCooldownTimer
@onready var camera_2d: Camera2D = $Camera2D

@export var direction1: Vector2 = Vector2(1, 0)
@export var player_scene: PackedScene
var teleport_particle_scene := preload("res://scenes/player/TeleportParticle.tscn")

# Estados
var is_teleporting := false
var can_teleport := true

# Salto
var coyote_time := 0.15
var coyote_timer := 0.0
var jump_buffer_time := 0.15
var jump_buffer_timer := 0.0

# Movimiento
const MAX_SPEED = 250.0
const ACCELERATION = 1200.0
const FRICTION = 1200.0
const TURN_BRAKE = 3000.0
const JUMP_VELOCITY = -350.0

func _ready() -> void:
	is_teleporting = false
	shadow.cant_teleport.connect(func(): can_teleport = false)
	shadow.can_teleport.connect(func(): can_teleport = true)

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if is_teleporting:
		return

	# Dirección hacia la sombra
	shadow_direction.rotation = direction1.angle()

	# JUMP BUFFERING
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer -= delta

	# COYOTE TIME
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta

	# SALTO
	if jump_buffer_timer > 0 and coyote_timer > 0:
		velocity.y = JUMP_VELOCITY
		jump_buffer_timer = 0
		coyote_timer = 0

	# SALTO VARIABLE (jump cut)
	if not Input.is_action_pressed("jump") and velocity.y < 0:
		velocity.y *= 0.5

	# GRAVEDAD
	if not is_on_floor():
		velocity += get_gravity() * delta

	# MOVIMIENTO HORIZONTAL
	var input_dir := Input.get_axis("left", "right")

	if input_dir != 0:
		var target_speed = input_dir * MAX_SPEED
		if sign(target_speed) != sign(velocity.x) and abs(velocity.x) > 10:
			velocity.x = move_toward(velocity.x, target_speed, TURN_BRAKE * delta)
		else:
			velocity.x = move_toward(velocity.x, target_speed, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

	move_and_slide()

	# TELETRANSPORTE
	if Input.is_action_just_pressed("action") and shadow_direction.is_colliding() and can_teleport:
		can_teleport = false
		tp_cooldown_timer.start()
		is_teleporting = true
		animated_sprite.play("tp")
		teleport_timer.start()

	# FLIP DEL SPRITE
	if input_dir != 0:
		pivot.scale.x = sign(input_dir)
		shadow.change_direction(sign(input_dir))

	# ANIMACIONES
	if not is_teleporting:
		if is_on_floor():
			if velocity.length() == 0:
				animated_sprite.play("idle")
				shadow.change_animation("idle")
			else:
				animated_sprite.play("run")
				shadow.change_animation("run")

	# SOMBRA
	if shadow_direction.is_colliding():
		shadow.show()
		var espacio = shadow_direction.get_collision_normal().normalized()*15
		shadow.move_to_point(shadow_direction.get_collision_point() + espacio) 
	else:
		shadow.visible = false
		shadow.global_position = shadow_direction.target_position

func _on_timer_timeout() -> void:
	spawn_teleport_particles()
	translate((shadow.global_position - global_position))
	velocity = Vector2.ZERO
	is_teleporting = false

func spawn_teleport_particles() -> void:
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

func _on_teleport_cooldown_timer_timeout() -> void:
	can_teleport = true

func death() -> void:
	var current_position = camera_2d.global_position
	remove_child(camera_2d)
	get_parent().add_child(camera_2d)
	camera_2d.global_position = current_position
	scale.y = 0.1
	translate(Vector2(0,15))
	queue_free()
