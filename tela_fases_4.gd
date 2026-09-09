extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	Global.fase_atual = 1
	Global.resetar_vidas()
	get_tree().change_scene_to_file("res://cena1.tscn")


func _on_button_2_pressed() -> void:
	Global.fase_atual = 2
	Global.resetar_vidas()
	get_tree().change_scene_to_file("res://f2_cena1.tscn")


func _on_button_3_pressed() -> void:
	Global.fase_atual = 3
	Global.resetar_vidas()
	get_tree().change_scene_to_file("res://f3_cena1.tscn")


func _on_button_4_pressed() -> void:
	Global.fase_atual = 4
	Global.resetar_vidas()
	get_tree().change_scene_to_file("res://f4_cena1.tscn")


func _on_button_5_pressed() -> void:
	get_tree().change_scene_to_file("res://telaInicial.tscn")
