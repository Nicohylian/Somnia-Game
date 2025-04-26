class_name Player
extends CharacterBody2D


@onready var animation_tree: AnimationTree = $AnimationTree

@onready var shadow_direction: RayCast2D = %ShadowDirection
@export var direction1: Vector2 = Vector2(1,0)
@onready var shadow: Shadow = $Shadow
@onready var pivot: Node2D = $pivot
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


@export var player_scene: PackedScene 



@onready var playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]


const SPEED = 300.0
const JUMP_VELOCITY = -400.0



func _ready() -> void:
	animation_tree.active = true
	

func _physics_process(delta: float) -> void:
	
	shadow_direction.rotation = direction1.angle()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("action"):
		if shadow_direction.is_colliding():
			velocity = Vector2(0,0)
			translate(shadow.global_position - global_position)
			
			

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if direction != 0:
		pivot.scale.x = sign(direction)
	
	if(is_on_floor()):
		if(velocity.length() == 0):
			playback.travel("idle")
		else:
			playback.travel("run")
	
	
	if shadow_direction.is_colliding():
		shadow.show()
		shadow.global_position = shadow_direction.get_collision_point()
	if not shadow_direction.is_colliding():
		shadow.visible = false
		shadow.global_position = shadow_direction.target_position
		
		
