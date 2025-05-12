extends MarginContainer

@onready var resume: Button = %Resume
@onready var restart: Button = %Restart
@onready var main_menu: Button = %MainMenu
@onready var quit: Button = %Quit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	resume.pressed.connect(_un_pause)
	restart.pressed.connect(_restart)
	main_menu.pressed.connect(_main_menu)
	quit.pressed.connect(func(): get_tree().quit())

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = not get_tree().paused
		visible = get_tree().paused

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _un_pause() -> void:
	get_tree().paused = false
	hide()

func _restart() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _main_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/UI/main_menu/main_menu.tscn")
