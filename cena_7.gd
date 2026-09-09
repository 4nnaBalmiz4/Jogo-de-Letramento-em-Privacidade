extends Node2D

@onready var anim = $animacaoFinal
@onready var botao = $TextureButton
@onready var player = $AudioStreamPlayer

func _ready():
	botao.visible = false

	
	# 2. Espera o tempo do primeiro frame para tocar o som no segundo
	# Ajuste o valor '0.1' para o tempo de duração de cada frame da sua animação
	await get_tree().create_timer(0.1).timeout
	if player:
		player.play()
	
	# Conecta os sinais
	anim.animation_finished.connect(_ao_terminar_animacao)
	botao.pressed.connect(_ao_clicar_botao)

func _ao_terminar_animacao():
	botao.visible = true

func _ao_clicar_botao():
	# Lembra de tocar o som de acerto/clique aqui se quiser feedback no botão!
	get_tree().change_scene_to_file("res://cena8.tscn")
