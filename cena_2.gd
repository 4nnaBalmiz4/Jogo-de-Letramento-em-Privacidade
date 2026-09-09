extends Node2D

var imagens_vida = [
	preload("res://framesJogo/barraVidaCompleta 1.png"),
	preload("res://framesJogo/barraVida-1 1.png"),
	preload("res://framesJogo/barraVida-2 1.png"),
	preload("res://framesJogo/barraVida-3 1.png"),
	preload("res://framesJogo/barraVida-4 1.png")
]

@onready var barra = $barraVida
@onready var missao = $MissaoAtivaFase1
@onready var missao_politica = $MissaoAtivaPolitica
@onready var notificacao_diario = $notificaçãoDiario
@onready var fechar_notificacao = $fecharNotificação
@onready var exclamacao = $exclamação

# DIÁRIO
@onready var abrir_diario = $abrirDiario
@onready var diario = $diarioFase1
@onready var fechar_diario = $fecharDiario

func _ready():
	Global.fase_atual = 1
	atualizar_barra_vida()

	if Global.perdeu_vida:
		_animar_perda_vida()
		Global.perdeu_vida = false

	missao.modulate.a = 0.0
	missao_politica.modulate.a = 0.0
	notificacao_diario.modulate.a = 0.0
	fechar_notificacao.modulate.a = 0.0
	exclamacao.modulate.a = 0.0

	# ESTADO INICIAL
	abrir_diario.visible = false
	abrir_diario.modulate.a = 0.3
	diario.visible = false
	fechar_diario.visible = false

	# CONEXÕES
	fechar_notificacao.pressed.connect(_fechar_notificacao_diario)
	abrir_diario.pressed.connect(_abrir_diario)
	fechar_diario.pressed.connect(_fechar_diario)
	abrir_diario.mouse_entered.connect(_mostrar_botao_diario)
	abrir_diario.mouse_exited.connect(_esconder_botao_diario)

	# MISSÃO
	if Global.voltou_para_cena2:
		await get_tree().create_timer(1.2).timeout
		_mostrar_missao_politica()
		Global.voltou_para_cena2 = false
	else:
		await get_tree().create_timer(1.2).timeout
		_mostrar_missao()

	# NOTIFICAÇÃO DIÁRIO
	await get_tree().create_timer(2.0).timeout

	if not Global.diario_ja_visto:
		_mostrar_notificacao_diario()
	else:
		abrir_diario.visible = true
		exclamacao.visible = false


func _process(delta: float) -> void:
	if Global.perdeu_vida:
		Global.perdeu_vida = false
		atualizar_barra_vida()
		_animar_perda_vida()
		if Global.vidas >= 4:
			Global.game_over()


# ===== VIDA =====

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


# ===== NOTIFICAÇÃO DIÁRIO =====

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
	Global.diario_ja_visto = true
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


# ===== BOTÃO DIÁRIO =====

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


# ===== MISSÕES =====

func _mostrar_missao():
	var som = AudioStreamPlayer.new()
	som.stream = preload("res://framesJogo/somNotificação.mp3")
	add_child(som)
	som.play()
	var tween = create_tween()
	tween.tween_property(missao, "modulate:a", 1.0, 0.5)

func _mostrar_missao_politica():
	var som = AudioStreamPlayer.new()
	som.stream = preload("res://framesJogo/somNotificação.mp3")
	add_child(som)
	som.play()
	var tween = create_tween()
	tween.tween_property(missao_politica, "modulate:a", 1.0, 0.5)
