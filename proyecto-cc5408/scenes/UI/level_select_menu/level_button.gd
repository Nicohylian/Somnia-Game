class_name LevelButton
extends Button

@export var id: int = 0

signal press_id(id: int)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(press)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func press() -> void:
	press_id.emit(id)
