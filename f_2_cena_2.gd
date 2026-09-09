extends Node2D

var imagens_vida = [
	preload("res://framesJogo/barraVidaCompleta 1.png"),
	preload("res://framesJogo/barraVida-1 1.png"),
	preload("res://framesJogo/barraVida-2 1.png"),
	preload("res://framesJogo/barraVida-3 1.png"),
	preload("res://framesJogo/barraVida-4 1.png")
]

# DIÁRIO
@onready var notificacao_diario = $notificaçãoDiario
@onready var fechar_notificacao = $fecharNotificação
@onready var exclamacao = $exclamação
@onready var abrir_diario = $abrirDiario
@onready var diario = $diarioFase1
@onready var fechar_diario = $fecharDiario

func _ready() -> void:
	Global.fase_atual = 2
	atualizar_barra_vida()

	# ESTADO INICIAL DO DIÁRIO
	notificacao_diario.modulate.a = 0.0
	fechar_notificacao.modulate.a = 0.0
	exclamacao.modulate.a = 0.0
	abrir_diario.visible = false
	abrir_diario.modulate.a = 0.3
	diario.visible = false
	fechar_diario.visible = false

	# CONEXÕES DO DIÁRIO
	fechar_notificacao.pressed.connect(_fechar_notificacao_diario)
	abrir_diario.pressed.connect(_abrir_diario)
	fechar_diario.pressed.connect(_fechar_diario)
	abrir_diario.mouse_entered.connect(_mostrar_botao_diario)
	abrir_diario.mouse_exited.connect(_esconder_botao_diario)

	# NOTIFICAÇÃO DIÁRIO
	await get_tree().create_timer(2.0).timeout

	if not Global.diario_ja_visto_f2:
		_mostrar_notificacao_diario()
	else:
		abrir_diario.visible = true
		exclamacao.visible = false

	# Verifica progresso ao voltar de uma cena
	verificar_progresso()


func _process(delta: float) -> void:
	if Global.perdeu_vida:
		Global.perdeu_vida = false
		atualizar_barra_vida()
		verificar_game_over()


# ===== SERVIDORES =====

func _on_button_pressed() -> void:
	Global.servidor1_visitado = true
	get_tree().change_scene_to_file("res://f2_cena3.tscn")

func _on_button_2_pressed() -> void:
	Global.servidor2_visitado = true
	get_tree().change_scene_to_file("res://f2_cena4.tscn")

func _on_button_3_pressed() -> void:
	Global.servidor3_visitado = true
	get_tree().change_scene_to_file("res://f2_cena5.tscn")


# ===== PROGRESSO =====

func verificar_progresso():
	var todos_visitados = Global.servidor1_visitado and Global.servidor2_visitado and Global.servidor3_visitado
	var todos_corretos = Global.servidor1_correto and Global.servidor2_correto and Global.servidor3_correto

	if todos_visitados and todos_corretos:
		await get_tree().create_timer(0.5).timeout
		await _transicao_para_cena6()
		get_tree().change_scene_to_file("res://f2_cena6.tscn")


func _transicao_para_cena6() -> void:
	# CanvasLayer garante que o overlay aparece por cima de tudo
	var canvas = CanvasLayer.new()
	add_child(canvas)

	var overlay = ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.0)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	canvas.add_child(overlay)

	var tween = create_tween()
	tween.tween_property(overlay, "color:a", 1.0, 0.8)
	await tween.finished


# ===== VIDA =====

func atualizar_barra_vida():
	var indice = clamp(Global.vidas, 0, imagens_vida.size() - 1)
	$barraVida.texture = imagens_vida[indice]

func verificar_game_over():
	if Global.vidas >= imagens_vida.size() - 1:
		Global.game_over()


# ===== DIÁRIO =====

func _mostrar_notificacao_diario():
	var som = AudioStreamPlayer.new()
	som.stream = preload("res://framesJogo/somNotificação.mp3")
	add_child(som)
	som.play()
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(notificacao_diario, "modulate:a", 1.0, 0.4)
	tween.tween_property(fechar_notificacao, "modulate:a", 1.0, 0.4)


func _fechar_notificacao_diario():
	Global.diario_ja_visto_f2 = true
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(notificacao_diario, "modulate:a", 0.0, 0.3)
	tween.tween_property(fechar_notificacao, "modulate:a", 0.0, 0.3)
	await get_tree().create_timer(0.3).timeout
	_iniciar_piscar_exclamacao()
	abrir_diario.visible = true


func _iniciar_piscar_exclamacao():
	exclamacao.modulate.a = 1.0
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(exclamacao, "modulate:a", 0.0, 0.4)
	tween.tween_property(exclamacao, "modulate:a", 1.0, 0.4)


func _mostrar_botao_diario():
	abrir_diario.modulate.a = 1.0

func _esconder_botao_diario():
	abrir_diario.modulate.a = 0.3

func _abrir_diario():
	diario.visible = true
	fechar_diario.visible = true
	exclamacao.visible = false

func _fechar_diario():
	diario.visible = false
	fechar_diario.visible = false
