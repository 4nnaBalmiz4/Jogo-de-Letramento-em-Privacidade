extends Node2D

@onready var botao = $Button

func _ready() -> void:
	if botao and not botao.pressed.is_connected(_on_button_pressed):
		botao.pressed.connect(_on_button_pressed)

	# Toca o som de game over
	var som = AudioStreamPlayer.new()
	som.stream = preload("res://framesJogo/somGameOver.mp3")
	add_child(som)
	som.play()
	
	# Efeito de fade-in (tela começa preta e revela)
	var canvas = CanvasLayer.new()
	canvas.layer = 10
	add_child(canvas)
	var overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 1.0)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	canvas.add_child(overlay)
	var tween = create_tween()
	tween.tween_property(overlay, "color:a", 0.0, 1.0).set_ease(Tween.EASE_OUT)
	tween.tween_callback(canvas.queue_free)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://telaInicial.tscn")
