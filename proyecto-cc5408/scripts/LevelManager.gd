extends Node

var current_level: int = 0
var levels: Array[String] = [
	"res://scenes/levels/level_1/level_1.tscn",
	"res://scenes/levels/level_2/level_2.tscn",
	"res://scenes/levels/level_3/level_3.tscn",
	"res://scenes/levels/level_4/level_4.tscn"
]

func go_to_next_level():
	
	if current_level < levels.size():
		get_tree().change_scene_to_file(levels[current_level])
	else:
		print("¡Juego completo!")
		get_tree().change_scene_to_file("res://scenes/UI/main_menu/main_menu.tscn")
	current_level += 1

func restart_current_level():
	get_tree().change_scene_to_file(levels[current_level])
