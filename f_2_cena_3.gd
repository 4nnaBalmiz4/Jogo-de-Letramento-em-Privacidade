extends Node2D

@onready var botao_confirmar = $botaoConfirmar
@onready var botao_cortar = $"botaoCortarConexão"

func _ready() -> void:
	botao_confirmar.pressed.connect(_on_botao_confirmar_pressed)
	botao_cortar.pressed.connect(_on_botao_cortar_conexao_pressed)

func _process(delta: float) -> void:
	pass


func _on_botao_confirmar_pressed() -> void:
	# CORRETO: Confirmar e continuar (Servidor em conformidade)
	Global.servidor1_correto = true
	if SomAcerto:
		SomAcerto.tocar_acerto()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://f2_cena2.tscn")


func _on_botao_cortar_conexao_pressed() -> void:
	# ERRADO: Cortar conexão indevidamente
	Global.servidor1_correto = false
	if Global.perder_vida():
		return
	if SomErro:
		SomErro.tocar_erro()
	_piscar_tela_vermelha()
	await get_tree().create_timer(0.6).timeout
	get_tree().change_scene_to_file("res://f2_cena2.tscn")


func _piscar_tela_vermelha() -> void:
	var canvas = CanvasLayer.new()
	add_child(canvas)
	var flash = ColorRect.new()
	flash.color = Color(1, 0, 0, 0.45)
	flash.set_anchors_preset(Control.PRESET_FULL_RECT)
	canvas.add_child(flash)
	var tween = create_tween()
	tween.tween_property(flash, "modulate:a", 0.0, 0.35)
	await tween.finished
	canvas.queue_free()
