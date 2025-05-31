extends MarginContainer

@onready var start: Button = %Start
@onready var credits: Button = %Credits
@onready var quit: Button = %Quit
@onready var select_level: Button = %SelectLevel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LevelManager.current_level = 0
	start.pressed.connect(func(): LevelManager.go_to_next_level())
	select_level.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/UI/level_select_menu/levels_select_menu.tscn"))
	quit.pressed.connect(func(): get_tree().quit())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
