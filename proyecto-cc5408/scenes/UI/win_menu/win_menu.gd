extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneTransition.fade_in()
	 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action"):
		get_tree().change_scene_to_file("res://scenes/UI/Credits/credits.tscn")
	
