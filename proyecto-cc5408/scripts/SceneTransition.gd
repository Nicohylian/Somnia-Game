# En SceneTransition.gd (Versión de Herramientas)
extends Node

var color_rect: ColorRect
var canvas: CanvasLayer

# Inicia un fundido a negro y se olvida. NO espera.
func fade_out(duration: float = 1.0):
	if is_instance_valid(color_rect): return
		
	color_rect = ColorRect.new()
	color_rect.color = Color(0, 0, 0, 0)
	color_rect.process_mode = Node.ProcessMode.PROCESS_MODE_ALWAYS

	canvas = CanvasLayer.new()
	canvas.layer = 1000
	canvas.process_mode = Node.ProcessMode.PROCESS_MODE_ALWAYS
	
	canvas.add_child(color_rect)
	get_tree().root.add_child(canvas)
	
	await get_tree().process_frame
	color_rect.anchors_preset = Control.PRESET_FULL_RECT

	var tween = create_tween()
	tween.set_pause_mode(Tween.TweenPauseMode.TWEEN_PAUSE_PROCESS)
	tween.tween_property(color_rect, "color", Color.BLACK, duration)

# Inicia un fundido desde negro y se limpia al terminar.
func fade_in(duration: float = 0.3):
	if not is_instance_valid(color_rect): return

	var tween = create_tween()
	tween.tween_property(color_rect, "color", Color(0, 0, 0, 0), duration)
	
	await tween.finished
	if is_instance_valid(canvas):
		canvas.queue_free()
	color_rect = null
	canvas = null
