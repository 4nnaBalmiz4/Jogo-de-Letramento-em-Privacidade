extends Node2D

const imagens_vida = [
	preload("res://framesJogo/barraVidaCompleta 1.png"),
	preload("res://framesJogo/barraVida-1 1.png"),
	preload("res://framesJogo/barraVida-2 1.png"),
	preload("res://framesJogo/barraVida-3 1.png"),
	preload("res://framesJogo/barraVida-4 1.png")
]

@onready var sprite1: Sprite2D = $Sprite2D
@onready var sprite2: Sprite2D = $Sprite2D2
@onready var sprite3: Sprite2D = $Sprite2D3
@onready var sprite4: Sprite2D = $Sprite2D4
@onready var sprite5: Sprite2D = $Sprite2D5
@onready var sprite6: Sprite2D = $Sprite2D6
@onready var sprite7: Sprite2D = $Sprite2D7

@onready var barra_vida: Sprite2D = $barraVida

@onready var dialog_panel: Panel = $DialogPanel
@onready var speaker_label: Label = $DialogPanel/SpeakerLabel
@onready var dialogue_label: Label = $DialogPanel/DialogueLabel

@onready var container_botoes: Control = $ContainerBotoes
@onready var botao_conforme: Button = $ContainerBotoes/BotaoConforme
@onready var botao_nao_conforme: Button = $ContainerBotoes/BotaoNaoConforme

@onready var color_rect: ColorRect = $ColorRect

@export var velocidade_texto: float = 0.03

var digitando: bool = false
var executando_transicao_sprite3: bool = false
var botoes_exibidos: bool = false
var fala_sprite7_concluida: bool = false
var trocando_para_f3_cena5: bool = false

func _ready() -> void:
	if color_rect:
		color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		color_rect.color = Color(0, 0, 0, 1.0)
		
		# 1. Fade in inicial da cena
		var tween_in = create_tween()
		tween_in.tween_property(color_rect, "color:a", 0.0, 0.8)
		await tween_in.finished
	
	# 2. Deixa o primeiro Sprite2D por um tempo (2 segundos)
	await get_tree().create_timer(2.0).timeout
	
	# 3. Transição de Zoom ultra fluida no personagem executivo (curva suave SINE)
	var tween_zoom = create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween_zoom.tween_property(sprite1, "scale", Vector2(1.22, 1.22), 1.8)
	tween_zoom.tween_property(sprite1, "position", Vector2(490, 300), 1.8)
	await tween_zoom.finished
	
	# 4. Cross-fade suave para o segundo Sprite2D da cena 4
	sprite2.modulate.a = 0.0
	sprite2.visible = true
	var tween_fade = create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween_fade.tween_property(sprite2, "modulate:a", 1.0, 0.5)
	tween_fade.tween_property(sprite1, "modulate:a", 0.0, 0.5)
	await tween_fade.finished
	sprite1.visible = false
	
	# 5. Apresenta a legenda com o diálogo do personagem
	if speaker_label:
		speaker_label.text = "EXECUTIVO DA RHMAX"
	if dialogue_label:
		dialogue_label.text = " Olá, Auditora. Somos uma plataforma inovadora de RH. Para oferecer a melhor experiência, precisamos conhecer bem nossos usuários. Vou te mostrar o que solicitamos deles..."
		
	if dialog_panel:
		dialog_panel.visible = true
		dialog_panel.modulate.a = 0.0
		var tween_panel = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween_panel.tween_property(dialog_panel, "modulate:a", 1.0, 0.4)
		await tween_panel.finished
	
	await _efetuar_efeito_maquina_escrever()
	
	# 6. Ao terminar a fala do executivo, transiciona para o Sprite2D3
	await get_tree().create_timer(1.0).timeout
	_transicionar_para_sprite3()

func atualizar_barra_vida() -> void:
	if barra_vida:
		var indice = clamp(Global.vidas, 0, 4)
		barra_vida.texture = imagens_vida[indice]

func _transicionar_para_sprite3() -> void:
	if executando_transicao_sprite3:
		return
	executando_transicao_sprite3 = true
	
	# Oculta legenda do diálogo
	if dialog_panel:
		var tween_panel = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween_panel.tween_property(dialog_panel, "modulate:a", 0.0, 0.4)
		await tween_panel.finished
		dialog_panel.visible = false
	
	# Transição de aparição suave para Sprite2D3
	if sprite3:
		sprite3.modulate.a = 0.0
		sprite3.visible = true
		var tween_s3 = create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween_s3.tween_property(sprite3, "modulate:a", 1.0, 0.6)
		tween_s3.tween_property(sprite2, "modulate:a", 0.0, 0.6)
		await tween_s3.finished
		sprite2.visible = false
		
		# Mostra o Sprite2D3 por 5 segundos
		await get_tree().create_timer(5.0).timeout
		
		# Transição no estilo "desligar TV" para o Sprite2D4
		_transicao_desligar_tv_para_sprite4()

func _transicao_desligar_tv_para_sprite4() -> void:
	if not sprite3:
		return
		
	var scale_original = sprite3.scale
	
	# Efeito de desligar TV: colapsa verticalmente para uma linha fina e fecha horizontalmente
	var tween_tv_off = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween_tv_off.tween_property(sprite3, "scale:y", 0.005, 0.25)
	tween_tv_off.tween_property(sprite3, "scale:x", 0.0, 0.15)
	await tween_tv_off.finished
	
	sprite3.visible = false
	sprite3.scale = scale_original
	
	# Transição para o Sprite2D4 (estilo ligar TV)
	if sprite4:
		var target_scale_4 = sprite4.scale
		sprite4.scale = Vector2(0.0, 0.005)
		sprite4.visible = true
		
		var tween_tv_on = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween_tv_on.tween_property(sprite4, "scale:x", target_scale_4.x, 0.15)
		tween_tv_on.tween_property(sprite4, "scale:y", target_scale_4.y, 0.25)
		await tween_tv_on.finished
		
		# Mostra o Sprite2D4 por 2 segundos
		await get_tree().create_timer(2.0).timeout
		
		# Transição para o Sprite2D5
		_transicionar_para_sprite5()

func _transicionar_para_sprite5() -> void:
	if not sprite5:
		return
		
	if sprite4 and sprite5:
		sprite5.modulate.a = 0.0
		sprite5.visible = true
		var tween_s5 = create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween_s5.tween_property(sprite5, "modulate:a", 1.0, 0.5)
		tween_s5.tween_property(sprite4, "modulate:a", 0.0, 0.5)
		await tween_s5.finished
		sprite4.visible = false
	else:
		sprite5.visible = true
		
	await get_tree().create_timer(1.5).timeout
	_transicionar_para_sprite6()

func _transicionar_para_sprite6() -> void:
	if not sprite6:
		return
		
	# Mostra a barra de vida a partir do Sprite2D6
	if barra_vida:
		atualizar_barra_vida()
		barra_vida.visible = true
		barra_vida.modulate.a = 0.0
		var tween_bv = create_tween()
		tween_bv.tween_property(barra_vida, "modulate:a", 1.0, 0.4)
		
	# Transição de sprite5 para sprite6
	if sprite5 and sprite6:
		sprite6.modulate.a = 0.0
		sprite6.visible = true
		var tween_s6 = create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween_s6.tween_property(sprite6, "modulate:a", 1.0, 0.5)
		tween_s6.tween_property(sprite5, "modulate:a", 0.0, 0.5)
		await tween_s6.finished
		sprite5.visible = false
	else:
		sprite6.visible = true
		
	# Apresenta a legenda da Auditora no Sprite2D6
	if speaker_label:
		speaker_label.text = "AUDITOR(A)"
	if dialogue_label:
		dialogue_label.text = "Será que está tudo certo? "
		
	if dialog_panel:
		dialog_panel.visible = true
		dialog_panel.modulate.a = 0.0
		var tween_panel2 = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween_panel2.tween_property(dialog_panel, "modulate:a", 1.0, 0.4)
		await tween_panel2.finished
		
	await _efetuar_efeito_maquina_escrever()
	
	await get_tree().create_timer(0.5).timeout
	_mostrar_botoes_com_efeito()

func _mostrar_botoes_com_efeito() -> void:
	if not container_botoes or botoes_exibidos:
		return
	botoes_exibidos = true
	
	container_botoes.visible = true
	container_botoes.modulate.a = 0.0
	container_botoes.scale = Vector2(0.7, 0.7)
	container_botoes.pivot_offset = Vector2(576, 545)
	
	var tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(container_botoes, "modulate:a", 1.0, 0.5)
	tween.tween_property(container_botoes, "scale", Vector2(1.0, 1.0), 0.5)

func _efetuar_efeito_maquina_escrever() -> void:
	if not dialogue_label:
		return
		
	dialogue_label.visible_characters = 0
	digitando = true
	
	var total_chars = dialogue_label.text.length()
	for i in range(total_chars):
		if not digitando:
			break
		dialogue_label.visible_characters += 1
		await get_tree().create_timer(velocidade_texto).timeout
		
	digitando = false

func _on_botao_conforme_pressed() -> void:
	if botao_conforme:
		botao_conforme.disabled = true
	if botao_nao_conforme:
		botao_nao_conforme.disabled = true
		
	if has_node("/root/SomAcerto") and SomAcerto:
		SomAcerto.tocar_acerto()
		
	if container_botoes:
		var tween_botoes = create_tween()
		tween_botoes.tween_property(container_botoes, "modulate:a", 0.0, 0.3)
		await tween_botoes.finished
		container_botoes.visible = false
		
	if dialog_panel:
		var tween_p = create_tween()
		tween_p.tween_property(dialog_panel, "modulate:a", 0.0, 0.3)
		await tween_p.finished
		dialog_panel.visible = false
		
	# Mostra Sprite2D7
	if sprite6 and sprite7:
		sprite7.modulate.a = 0.0
		sprite7.visible = true
		var tween_s7 = create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween_s7.tween_property(sprite7, "modulate:a", 1.0, 0.5)
		tween_s7.tween_property(sprite6, "modulate:a", 0.0, 0.5)
		await tween_s7.finished
		sprite6.visible = false
	elif sprite7:
		sprite7.visible = true

	# No Sprite2D7 adicione o Auditor(a) falando: "Aqui está tudo certo! Vamos continuar!"
	if speaker_label:
		speaker_label.text = "AUDITOR(A)"
	if dialogue_label:
		dialogue_label.text = "Aqui está tudo certo! Vamos continuar!"
		
	if dialog_panel:
		dialog_panel.visible = true
		dialog_panel.modulate.a = 0.0
		var tween_panel_s7 = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween_panel_s7.tween_property(dialog_panel, "modulate:a", 1.0, 0.4)
		await tween_panel_s7.finished
		
	await _efetuar_efeito_maquina_escrever()
	fala_sprite7_concluida = true
	
	# Ao fim da fala do sprite2d7, vai para a cena 5 da fase 3 (res://f3_cena5.tscn)
	await get_tree().create_timer(1.2).timeout
	_ir_para_f3_cena5()

func _ir_para_f3_cena5() -> void:
	if trocando_para_f3_cena5:
		return
	trocando_para_f3_cena5 = true
	
	if color_rect:
		color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
		var tween_out = create_tween()
		tween_out.tween_property(color_rect, "color:a", 1.0, 0.6)
		await tween_out.finished
		
	get_tree().change_scene_to_file("res://f3_cena5.tscn")

func _on_botao_nao_conforme_pressed() -> void:
	if botao_conforme:
		botao_conforme.disabled = true
	if botao_nao_conforme:
		botao_nao_conforme.disabled = true
		
	if has_node("/root/SomErro") and SomErro:
		SomErro.tocar_erro()
		
	_piscar_tela_vermelha()
	
	if Global.has_method("perder_vida"):
		if Global.perder_vida():
			return
			
	atualizar_barra_vida()
	
	await get_tree().create_timer(0.8).timeout
	if botao_conforme:
		botao_conforme.disabled = false
	if botao_nao_conforme:
		botao_nao_conforme.disabled = false

func _piscar_tela_vermelha() -> void:
	var canvas = CanvasLayer.new()
	add_child(canvas)
	var flash = ColorRect.new()
	flash.color = Color(1, 0, 0, 0.45)
	flash.set_anchors_preset(Control.PRESET_FULL_RECT)
	canvas.add_child(flash)
	var tween = create_tween()
	tween.tween_property(flash, "modulate:a", 0.0, 0.4)
	await tween.finished
	canvas.queue_free()

func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and event.pressed) or (event is InputEventKey and event.pressed):
		if digitando and dialogue_label:
			dialogue_label.visible_characters = dialogue_label.text.length()
			digitando = false
		elif fala_sprite7_concluida and not trocando_para_f3_cena5:
			_ir_para_f3_cena5()
		elif not digitando and not executando_transicao_sprite3:
			_transicionar_para_sprite3()
