extends MarginContainer

@onready var levels_container: GridContainer = %LevelsContainer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in levels_container.get_children():
		if(child is LevelButton):
			child.press_id.connect(select_level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func select_level(id: int) -> void:
	# Llama a la nueva función que creamos, pasándole el 'id' del botón.
	LevelManager.go_to_specific_level(id)
