class_name Enemy
extends CharacterBody2D

@export var speed := 100.0
@export var boosted_speed := 180.0
@export var detection_range := 150.0

@onready var player: Player = get_tree().get_first_node_in_group("Player")
@onready var animated_sprite := $AnimatedSprite2D
@onready var raycast := $RayCast2D

var original_scale := Vector2.ONE
var is_chasing_now := false
@onready var area_2d: Area2D = $Area2D

func _ready():
	area_2d.body_entered.connect(_on_body_entered)
	original_scale = animated_sprite.scale
	animated_sprite.visible = true
	animated_sprite.modulate.a = 1.0
	animated_sprite.play("IDLE")
	raycast.enabled = true

func _physics_process(delta):
	if player == null:
		return

	# Dirección del raycast hacia el jugador
	var dir_to_player = player.global_position - global_position
	raycast.target_position = dir_to_player.normalized() * detection_range
	var sees_player = raycast.is_colliding() and raycast.get_collider() is Player

	# Si acaba de ver al jugador
	if sees_player and not is_chasing_now:
		is_chasing_now = true
		animated_sprite.play("transformation")
		await animated_sprite.animation_finished
		animated_sprite.play("Attack")

	# Si lo sigue viendo
	if sees_player:
		var dir = dir_to_player.normalized()
		velocity = dir * boosted_speed
		move_and_slide()
		if dir.x != 0:
			animated_sprite.scale.x = original_scale.x * sign(dir.x)

	# Si deja de verlo
	elif is_chasing_now and not sees_player:
		is_chasing_now = false
		velocity = Vector2.ZERO
		animated_sprite.play("IDLE")
		
func _on_body_entered(body):
	if body is Player:  # O usa el nombre de tu clase de jugador si cambiaste el class_name
		body.death()  # Llama a la función de muerte del jugador
