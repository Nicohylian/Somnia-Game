class_name Level
extends Node2D

@onready var player: Player = $Player
@onready var door: Area2D = $Door
@onready var level_pause: CanvasLayer = $level_pause
@onready var label: Label = $level_pause/Label
@onready var pause_menu: MarginContainer = $level_pause/PauseMenu
@onready var bar_sprite: TextureProgressBar = $CanvasLayer/Healthbar/Barra
@onready var fog_rect: ColorRect = $FogRect

# --- NUEVAS VARIABLES PARA EL SHOCKWAVE ---
# Asegúrate de que las rutas a los nodos coincidan con tu escena.
@onready var shockwave_rect: ColorRect = $EffectLayer/ColorRect
@onready var effect_timer: Timer = $EffectTimer

var lights: Array
@export var total_time: float  # Tiempo total en segundos
var time_left: float
var player_live:= true


func _ready() -> void:
	var level_width = 3000.0  # El ancho de tu nivel
	var level_height = 3000.0 # La altura de tu nivel
	fog_rect.size = Vector2(level_width, level_height)
	fog_rect.position = Vector2(-1000,-1000)
	SceneTransition.fade_in()
	player.defeat.connect(_lose_level)
	time_left = total_time
	if MusicManager.current_stream != preload("res://audios/themes/theme 1_org.ogg"):
		MusicManager.play_music(preload("res://audios/themes/theme 1_org.ogg"))
	lights = get_tree().get_nodes_in_group("Light")
	door.body_entered.connect(_win_level)
	update_healthbar()

	# Conectamos la señal del timer. Se llamará a esta función cuando el timer termine.
	effect_timer.timeout.connect(_on_effect_timer_timeout)
	
	# Ocultamos el ColorRect al inicio para que no se vea.
	shockwave_rect.hide()

func _process(delta: float) -> void:
	if !player_live:
		return
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
		# Hacemos que el jugador no se pueda mover ni ser afectado por la física.
		player.set_physics_process(false)
		
		# ¡Iniciamos el efecto de shockwave!
		_start_shockwave_effect()

func _lose_level() -> void:
	player_live = false
	player.death()
	
	_show_end_label("You Lose")

func _show_end_label(text: String) -> void:
	var end_label := Label.new()
	end_label.text = text
	end_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	end_label.set_anchors_preset(Control.PRESET_CENTER_TOP)
	level_pause.add_child(end_label)

	get_tree().paused = true
	pause_menu.show()

func _start_shockwave_effect() -> void:
	# La duración que queremos para ambas animaciones.
	var animation_duration = 1.0

	# 1. ¡LANZAMOS EL FADE OUT!
	# Esta función ahora no bloquea la ejecución, solo inicia la animación.
	SceneTransition.fade_out(animation_duration)

	# 2. ¡LANZAMOS EL SHOCKWAVE SIMULTÁNEAMENTE!
	get_tree().paused = true
	shockwave_rect.show()
	var screen_position = player.get_global_transform_with_canvas().origin
	var screen_size = get_viewport_rect().size
	var normalized_center = screen_position / screen_size
	shockwave_rect.material.set_shader_parameter("center", normalized_center)
	
	var tween = create_tween().set_pause_mode(Tween.TweenPauseMode.TWEEN_PAUSE_PROCESS)
	tween.tween_property(shockwave_rect.material, "shader_parameter/radius", 1.0, animation_duration).from(0.0)
	
	# 3. El timer espera a que AMBAS animaciones terminen.
	effect_timer.start(animation_duration)

func _on_effect_timer_timeout() -> void:
	# Para cuando esto se ejecute, la pantalla ya estará en negro.
	shockwave_rect.hide()
	shockwave_rect.material.set_shader_parameter("radius", 0.0)
	get_tree().paused = false

	# Obtenemos la ruta del siguiente nivel desde el LevelManager.
	var next_level_path = LevelManager.get_next_level_path()
	
	# Cambiamos la escena. El fade in se gestionará en el _ready del nuevo nodo.
	get_tree().change_scene_to_file(next_level_path)
