extends Node2D

@onready var botao = $TextureButton

func _ready():
	botao.visible = false
	
	# Conecta primeiro
	botao.pressed.connect(_ao_clicar_botao)
	
	# Espera 2 segundos
	await get_tree().create_timer(2.0).timeout
	
	# Mostra o botão
	botao.visible = true

func _ao_clicar_botao():
	Global.voltou_para_cena2 = true
	get_tree().change_scene_to_file("res://cena5.tscn")
