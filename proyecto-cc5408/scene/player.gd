class_name Player
extends CharacterBody2D

@onready var shadow_direction: RayCast2D = %ShadowDirection
@export var direction: Vector2 = Vector2(1,0)
@onready var shadow: Shadow = $Shadow




const SPEED = 300.0
const JUMP_VELOCITY = -400.0





func _physics_process(delta: float) -> void:
	
	shadow_direction.rotation = direction.angle()
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("action"):
		if shadow_direction.is_colliding():
			global_position = shadow.global_position

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	
	
	if shadow_direction.is_colliding():
		shadow.show()
		shadow.global_position = shadow_direction.get_collision_point()
	if not shadow_direction.is_colliding():
		shadow.visible = false
		shadow.global_position = shadow_direction.target_position
		
		
