extends Node2D

var imagens_vida = [
	preload("res://framesJogo/barraVidaCompleta 1.png"),
	preload("res://framesJogo/barraVida-1 1.png"),
	preload("res://framesJogo/barraVida-2 1.png"),
	preload("res://framesJogo/barraVida-3 1.png"),
	preload("res://framesJogo/barraVida-4 1.png")
]

@onready var barra = $barraVida

func _ready():
	Global.fase_atual = 1
	atualizar_barra_vida()

	if Global.perdeu_vida:
		_animar_perda_vida()
		Global.perdeu_vida = false


func _process(delta: float) -> void:
	if Global.perdeu_vida:
		Global.perdeu_vida = false
		atualizar_barra_vida()
		_animar_perda_vida()
		if Global.vidas >= 4:
			Global.game_over()


func atualizar_barra_vida():
	var indice = clamp(Global.vidas, 0, imagens_vida.size() - 1)
	barra.texture = imagens_vida[indice]

func _animar_perda_vida():
	var tween = create_tween()
	tween.tween_property(barra, "modulate:a", 0.0, 0.1)
	tween.tween_property(barra, "modulate:a", 1.0, 0.1)
	tween.tween_property(barra, "modulate:a", 0.0, 0.1)
	tween.tween_property(barra, "modulate:a", 1.0, 0.1)
	tween.tween_property(barra, "modulate:a", 0.0, 0.1)
	tween.tween_property(barra, "modulate:a", 1.0, 0.1)
