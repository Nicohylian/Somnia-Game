extends Node

@onready var player := AudioStreamPlayer.new()
var current_stream: AudioStream = null

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(player)
	player.bus = "Music"
	player.autoplay = false
	player.volume_db = 0
	
func play_music(stream: AudioStream):
	if current_stream == stream:
		return  # Ya está sonando esa música
	current_stream = stream
	player.stream = stream
	player.play()
