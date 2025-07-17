extends Node

# El índice del nivel que se está jugando actualmente. Empezamos en 0.
var current_level_index: int = 0

var levels: Array[String] = [
	"res://scenes/levels/level_1/level.tscn",
	"res://scenes/levels/level_2/level.tscn",
	"res://scenes/levels/level_3/level.tscn",
	"res://scenes/levels/level_4/level.tscn",
	"res://scenes/levels/level_5/level.tscn",
	"res://scenes/levels/level_6/level.tscn",
	"res://scenes/levels/level_7/level.tscn",
	"res://scenes/levels/level_8/level.tscn",
	"res://scenes/levels/level_9/level.tscn",
	"res://scenes/levels/level_10/level.tscn",
	"res://scenes/levels/level_11/level.tscn",
	"res://scenes/levels/level_12/level.tscn"
]


# Para avanzar al siguiente nivel desde un nivel de juego.
func get_next_level_path() -> String:
	current_level_index += 1
	if current_level_index < levels.size():
		return levels[current_level_index]
	else:
		return "res://scenes/UI/win_menu/win_menu.tscn"

# Para empezar el juego desde el menú principal.
func start_game():
	current_level_index = 0
	get_tree().change_scene_to_file(levels[current_level_index])

# Para ir a un nivel específico desde el selector de niveles.
func go_to_specific_level(index: int):
	if index >= 0 and index < levels.size():
		current_level_index = index
		get_tree().change_scene_to_file(levels[index])
	else:
		print("Error: Se intentó cargar un nivel inválido con índice: ", index)
