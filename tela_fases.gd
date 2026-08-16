extends Node2D

@onready var video_player = $VideoStreamPlayer
@onready var mapa = $MapaFases
@onready var botao_fase1 = $MapaFases/BotaoFase1
@onready var botao_fase2 = $MapaFases/BotaoFase2
@onready var botao_fase3 = $MapaFases/BotaoFase3

var brilho_tween: Tween

func _ready():
	# Conecta os botões
	botao_fase1.pressed.connect(_on_botao_fase1_pressed)
	botao_fase2.pressed.connect(_on_botao_fase2_pressed)
	botao_fase3.pressed.connect(_on_botao_fase3_pressed)

	if Global.fase_atual >= 3:
		# Vindo da fase 2 concluída: mostra o mapa direto com fase 3 piscando
		video_player.visible = false
		video_player.stop()
		mapa.visible = true
		_iniciar_brilho(botao_fase3)
	elif Global.fase_atual >= 2:
		# Vindo da fase 1 concluída: mostra o mapa direto com fase 2 piscando
		video_player.visible = false
		video_player.stop()
		mapa.visible = true
		_iniciar_brilho(botao_fase2)
	else:
		# Primeira vez: mostra o vídeo e depois o mapa com fase 1 piscando
		mapa.visible = false
		video_player.finished.connect(_on_video_finished)

func _on_video_finished():
	# Esconde o vídeo e mostra o mapa
	video_player.visible = false
	mapa.visible = true
	# Inicia o efeito de brilho no botão da fase 1
	_iniciar_brilho(botao_fase1)

func _iniciar_brilho(botao: Button):
	if brilho_tween:
		brilho_tween.kill()
	# Efeito de cor: alterna entre branco superiluminado, laranja vibrante e ciano elétrico
	brilho_tween = create_tween().set_loops()
	brilho_tween.tween_property(botao, "modulate", Color(8.0, 7.0, 0.0, 1.0), 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	brilho_tween.tween_property(botao, "modulate", Color(0.0, 6.0, 8.0, 1.0), 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	brilho_tween.tween_property(botao, "modulate", Color(8.0, 0.0, 6.0, 1.0), 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	brilho_tween.tween_property(botao, "modulate", Color(8.0, 7.0, 0.0, 1.0), 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	# Efeito de escala: pulsa entre tamanho normal e maior
	var escala_tween = create_tween().set_loops()
	escala_tween.tween_property(botao, "scale", Vector2(1.3, 1.3), 0.3).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	escala_tween.tween_property(botao, "scale", Vector2(1.0, 1.0), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _on_botao_fase1_pressed():
	if brilho_tween:
		brilho_tween.kill()
	get_tree().change_scene_to_file("res://cena1.tscn")

func _on_botao_fase2_pressed():
	if brilho_tween:
		brilho_tween.kill()
	Global.vidas = 0
	Global.perdeu_vida = false
	get_tree().change_scene_to_file("res://f2_cena1.tscn")

func _on_botao_fase3_pressed():
	if brilho_tween:
		brilho_tween.kill()
	Global.vidas = 0
	Global.perdeu_vida = false
	get_tree().change_scene_to_file("res://f3_cena1.tscn")
