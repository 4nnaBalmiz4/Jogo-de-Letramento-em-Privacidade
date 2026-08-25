extends Node2D

func _ready() -> void:
	$AudioStreamPlayer.play()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://tela_fases_4.tscn")
