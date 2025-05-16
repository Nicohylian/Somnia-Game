extends Node2D

@onready var player: Player = %Player
@onready var light: Node2D = %Light
@onready var door: Area2D = %Door
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var label: Label = $CanvasLayer/Label
@onready var pause_menu: MarginContainer = %PauseMenu
@onready var healthbar: Node2D = %Healthbar
@onready var bar_sprite: TextureProgressBar = player.get_node("Healthbar/Barra")

var lights: Array
var total_time := 10.0  # Tiempo total (segundos)
var time_left := total_time

func _ready() -> void:
	lights = get_tree().get_nodes_in_group("Light")
	door.body_entered.connect(_win_level)

	update_healthbar()  # Asegura que la barra comience llena

func _process(delta: float) -> void:
	var current_light: Light = null
	for light in lights:
		if current_light == null or (player.global_position - light.global_position).length() < (player.global_position - current_light.global_position).length():
			current_light = light
	
	var shadow_direction: Vector2 = player.global_position - current_light.global_position
	player.direction1 = shadow_direction

	# Actualizar tiempo y barra
	time_left -= delta
	update_healthbar()

	if time_left <= 0:
		_lose_level()

func update_healthbar() -> void:
	var percentage: float = clamp(time_left / total_time, 0.0, 1.0)

	bar_sprite.value = percentage * 100.0  # Asumiendo que max_value = 100


func _win_level(body: Node2D) -> void:
	if body is Player:
		var label: Label = Label.new()
		label.text = "You Win"
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.set_anchors_preset(Control.PRESET_CENTER_TOP)
		canvas_layer.add_child(label)
		get_tree().paused = true
		pause_menu.show()

func _lose_level() -> void:
	var label: Label = Label.new()
	label.text = "You Lose"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.set_anchors_preset(Control.PRESET_CENTER_TOP)
	canvas_layer.add_child(label)
	get_tree().paused = true
	pause_menu.show()
