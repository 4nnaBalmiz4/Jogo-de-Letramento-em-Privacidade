extends Node

@onready var player = $AudioStreamPlayer
@onready var botao_continuar = $botaoContinuar

func _ready():
	player.stream.loop = false
	player.play()
	botao_continuar.pressed.connect(_on_button_pressed)


func _on_button_pressed() -> void:
	Global.fase_atual = 2
	get_tree().change_scene_to_file("res://tela_fases_2.tscn")
