class_name Level
extends Node2D

@onready var player: Player = %Player
@onready var light: Node2D = %Light
@onready var door: Area2D = %Door
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var timer: Timer = $CanvasLayer/Timer
@onready var label: Label = $CanvasLayer/Label
@onready var pause_menu: MarginContainer = %PauseMenu

var lights: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lights = get_tree().get_nodes_in_group("Light")
	door.body_entered.connect(_win_level)
	timer.timeout.connect(_lose_level)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var current_light: Light = null
	for light in lights:
		if current_light == null:
			current_light = light
		else:
			if (player.global_position - light.global_position).length() < (player.global_position - current_light.global_position).length():
				current_light = light
		
	var shadow_direction: Vector2 = player.global_position - current_light.global_position
	player.direction1 = shadow_direction
	var time = str(snapped( timer.time_left, 0.01) )
	label.text = "time: " + time
	
func _win_level(body: Node2D) -> void:
	if body is Player:
		var label: Label = Label.new()
		label.text = "You Win"
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.set_anchors_preset(Control.PRESET_CENTER_TOP)
		canvas_layer.add_child(label)
		timer.stop()
		get_tree().paused = true
		pause_menu.show()

func _lose_level() -> void:
	var label: Label = Label.new()
	label.text = "You Lose"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.set_anchors_preset(Control.PRESET_CENTER_TOP)
	canvas_layer.add_child(label)
	timer.stop()
	get_tree().paused = true
	pause_menu.show()
