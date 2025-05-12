extends Node2D

@onready var player: Player = $Player
@onready var door: Area2D = $Door
@onready var level_pause: CanvasLayer = $level_pause
@onready var label: Label = $level_pause/Label
@onready var pause_menu: MarginContainer = $level_pause/PauseMenu
@onready var bar_sprite: TextureProgressBar = $CanvasLayer/Healthbar/Barra

var lights: Array
var total_time := 4.0  # Tiempo total en segundos
var time_left := total_time

func _ready() -> void:
	lights = get_tree().get_nodes_in_group("Light")
	door.body_entered.connect(_win_level)
	update_healthbar()

func _process(delta: float) -> void:
	# 1. Encuentra la luz más cercana
	var closest_light: Light = null
	for light in lights:
		if closest_light == null or player.global_position.distance_to(light.global_position) < player.global_position.distance_to(closest_light.global_position):
			closest_light = light

	if closest_light:
		var shadow_direction = player.global_position - closest_light.global_position
		player.direction1 = shadow_direction

	# 2. Timer
	time_left -= delta
	update_healthbar()
	if time_left <= 0:
		_lose_level()

func update_healthbar() -> void:
	var percentage: float = clamp(time_left / total_time, 0.0, 1.0)
	bar_sprite.value = percentage * 100.0

func _win_level(body: Node2D) -> void:
	if body is Player:
		LevelManager.go_to_next_level()

func _lose_level() -> void:
	_show_end_label("You Lose")

func _show_end_label(text: String) -> void:
	var end_label := Label.new()
	end_label.text = text
	end_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	end_label.set_anchors_preset(Control.PRESET_CENTER_TOP)
	level_pause.add_child(end_label)

	get_tree().paused = true
	pause_menu.show()
