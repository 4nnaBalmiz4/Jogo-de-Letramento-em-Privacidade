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

@onready var barra_vida: Sprite2D = $barraVida

@onready var dialog_panel: Panel = $DialogPanel
@onready var speaker_label: Label = $DialogPanel/SpeakerLabel
@onready var dialogue_label: Label = $DialogPanel/DialogueLabel

@onready var container_botoes: Control = $ContainerBotoes
@onready var botao_conforme: Button = $ContainerBotoes/BotaoConforme
@onready var botao_nao_conforme: Button = $ContainerBotoes/BotaoNaoConforme

@onready var color_rect: ColorRect = $ColorRect
@onready var botao_avancar: Button = $BotaoAvancar

@export var velocidade_texto: float = 0.03

var digitando: bool = false
var executando_transicao_sprite2: bool = false
var botoes_exibidos: bool = false
var fala_sprite4_concluida: bool = false

func _ready() -> void:
	if color_rect:
		color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		color_rect.color = Color(0, 0, 0, 1.0)
		
		# Fade in inicial da cena 5
		var tween_in = create_tween()
		tween_in.tween_property(color_rect, "color:a", 0.0, 0.8)
		await tween_in.finished
	
	# Exibe o painel de diálogo com a fala do executivo
	if speaker_label:
		speaker_label.text = "EXECUTIVO DA BURGUER EXPRESS"
	if dialogue_label:
		dialogue_label.text = "Excelente! Agora, temos mais algumas solicitações..."
		
	if dialog_panel:
		dialog_panel.visible = true
		dialog_panel.modulate.a = 0.0
		var tween_panel = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween_panel.tween_property(dialog_panel, "modulate:a", 1.0, 0.4)
		await tween_panel.finished
		
	await _efetuar_efeito_maquina_escrever()
	
	# Ao terminar a fala do executivo, mostra o Sprite2D2
	await get_tree().create_timer(1.0).timeout
	_transicionar_para_sprite2()

func atualizar_barra_vida() -> void:
	if barra_vida:
		var indice = clamp(Global.vidas, 0, 4)
		barra_vida.texture = imagens_vida[indice]

func _transicionar_para_sprite2() -> void:
	if executando_transicao_sprite2:
		return
	executando_transicao_sprite2 = true
	
	# Oculta legenda do diálogo
	if dialog_panel:
		var tween_panel = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween_panel.tween_property(dialog_panel, "modulate:a", 0.0, 0.4)
		await tween_panel.finished
		dialog_panel.visible = false
		
	# Aparição suave do Sprite2D2 (cartaoDadosSolicitantes 2)
	if sprite2:
		sprite2.modulate.a = 0.0
		sprite2.visible = true
		var tween_s2 = create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween_s2.tween_property(sprite2, "modulate:a", 1.0, 0.6)
		if sprite1:
			tween_s2.tween_property(sprite1, "modulate:a", 0.0, 0.6)
		await tween_s2.finished
		if sprite1:
			sprite1.visible = false
		
		# Mostra o Sprite2D2 por 5 segundos
		await get_tree().create_timer(5.0).timeout
		
		# Efeito desligar TV e mostrar Sprite2D3
		_transicao_desligar_tv_para_sprite3()

func _transicao_desligar_tv_para_sprite3() -> void:
	if not sprite2:
		return
		
	var scale_original = sprite2.scale
	
	# Efeito de desligar TV: colapsa verticalmente para uma linha fina e fecha horizontalmente
	var tween_tv_off = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween_tv_off.tween_property(sprite2, "scale:y", 0.005, 0.25)
	tween_tv_off.tween_property(sprite2, "scale:x", 0.0, 0.15)
	await tween_tv_off.finished
	
	sprite2.visible = false
	sprite2.scale = scale_original
	
	# Transição para o Sprite2D3 (estilo ligar TV)
	if sprite3:
		var target_scale_3 = sprite3.scale
		sprite3.scale = Vector2(0.0, 0.005)
		sprite3.visible = true
		
		var tween_tv_on = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween_tv_on.tween_property(sprite3, "scale:x", target_scale_3.x, 0.15)
		tween_tv_on.tween_property(sprite3, "scale:y", target_scale_3.y, 0.25)
		await tween_tv_on.finished
		
		# Mostra a barra de vida
		if barra_vida:
			atualizar_barra_vida()
			barra_vida.visible = true
			barra_vida.modulate.a = 0.0
			var tween_bv = create_tween()
			tween_bv.tween_property(barra_vida, "modulate:a", 1.0, 0.4)
		
		# Fala do Auditor(a) no Sprite2D3
		if speaker_label:
			speaker_label.text = "AUDITOR(A)"
		if dialogue_label:
			dialogue_label.text = "Mais dados?? Deixe eu analisar bem isso."
			
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
	
	# Oculta o quadro de fala ao mostrar os botões
	if dialog_panel:
		var tween_panel_hide = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween_panel_hide.tween_property(dialog_panel, "modulate:a", 0.0, 0.3)
		await tween_panel_hide.finished
		dialog_panel.visible = false
	
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

func _on_botao_nao_conforme_pressed() -> void:
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
		
	# Transição dramática para Sprite2D4
	# 1. Flash branco rápido
	var canvas_flash = CanvasLayer.new()
	canvas_flash.layer = 50
	add_child(canvas_flash)
	var flash_branco = ColorRect.new()
	flash_branco.color = Color(1, 1, 1, 0.0)
	flash_branco.set_anchors_preset(Control.PRESET_FULL_RECT)
	canvas_flash.add_child(flash_branco)
	
	var tween_flash_in = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween_flash_in.tween_property(flash_branco, "color:a", 0.85, 0.15)
	await tween_flash_in.finished
	
	# 2. Troca os sprites durante o flash
	if sprite3:
		sprite3.visible = false
	if sprite4:
		sprite4.visible = true
		sprite4.modulate.a = 1.0
	
	# 3. Shake da tela (tremor dramático)
	var pos_original = position
	for i in range(8):
		var offset_x = randf_range(-12, 12)
		var offset_y = randf_range(-8, 8)
		position = pos_original + Vector2(offset_x, offset_y)
		await get_tree().create_timer(0.04).timeout
	position = pos_original
	
	# 4. Flash some gradualmente
	var tween_flash_out = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween_flash_out.tween_property(flash_branco, "color:a", 0.0, 0.5)
	await tween_flash_out.finished
	canvas_flash.queue_free()
	
	# 5. Fala do executivo irritado (imediatamente ao iniciar Sprite2D4)
	if speaker_label:
		speaker_label.text = "EXECUTIVO DA BURGUER EXPRESS"
	if dialogue_label:
		dialogue_label.text = "Você está atrapalhando nossa inovação! Todos os apps modernos fazem isso! Como vamos personalizar a experiência sem esses dados?"
		
	if dialog_panel:
		dialog_panel.z_index = 10
		dialog_panel.visible = true
		dialog_panel.modulate.a = 0.0
		var tween_panel_s4 = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween_panel_s4.tween_property(dialog_panel, "modulate:a", 1.0, 0.4)
		await tween_panel_s4.finished
		
	await _efetuar_efeito_maquina_escrever()
	fala_sprite4_concluida = true
	
	# 6. Após 2 segundos, transição para Sprite2D5 com fala do Auditor(a)
	await get_tree().create_timer(2.0).timeout
	_transicionar_para_sprite5()

func _transicionar_para_sprite5() -> void:
	# Oculta o painel de diálogo
	if dialog_panel:
		var tween_hide = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween_hide.tween_property(dialog_panel, "modulate:a", 0.0, 0.4)
		await tween_hide.finished
		dialog_panel.visible = false
	
	# Troca Sprite2D4 por Sprite2D5 com crossfade
	if sprite5:
		sprite5.modulate.a = 0.0
		sprite5.visible = true
		var tween_cross = create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween_cross.tween_property(sprite5, "modulate:a", 1.0, 0.6)
		if sprite4:
			tween_cross.tween_property(sprite4, "modulate:a", 0.0, 0.6)
		await tween_cross.finished
		if sprite4:
			sprite4.visible = false
	
	# Fala do Auditor(a)
	if speaker_label:
		speaker_label.text = "AUDITOR(A)"
	if dialogue_label:
		dialogue_label.text = "Personalização não justifica invasão de privacidade. Se você quer fotos, explique POR QUÊ e PARA QUÊ. 'Melhor experiência' não é finalidade, é marketing."
	
	if dialog_panel:
		dialog_panel.z_index = 10
		dialog_panel.visible = true
		dialog_panel.modulate.a = 0.0
		var tween_panel_s5 = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween_panel_s5.tween_property(dialog_panel, "modulate:a", 1.0, 0.4)
		await tween_panel_s5.finished
	
	await _efetuar_efeito_maquina_escrever()
	
	# Mostra botão '>>' para avançar
	if botao_avancar:
		botao_avancar.visible = true
		botao_avancar.modulate.a = 0.0
		var tween_btn = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween_btn.tween_property(botao_avancar, "modulate:a", 1.0, 0.4)

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

func _on_botao_avancar_pressed() -> void:
	if botao_avancar:
		botao_avancar.disabled = true
	
	# Fade out para a próxima cena
	if color_rect:
		color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
		var tween_fade = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		tween_fade.tween_property(color_rect, "color:a", 1.0, 0.6)
		await tween_fade.finished
	
	get_tree().change_scene_to_file("res://f3_cena6.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and event.pressed) or (event is InputEventKey and event.pressed):
		if digitando and dialogue_label:
			dialogue_label.visible_characters = dialogue_label.text.length()
			digitando = false
		elif not digitando and not executando_transicao_sprite2:
			_transicionar_para_sprite2()
