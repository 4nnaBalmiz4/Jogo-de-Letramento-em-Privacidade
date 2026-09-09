extends Node2D

func _ready() -> void:
	$AudioStreamPlayer.play()


func _on_button_pressed() -> void:
	Global.fase_atual = 4
	get_tree().change_scene_to_file("res://tela_fases_4.tscn")
