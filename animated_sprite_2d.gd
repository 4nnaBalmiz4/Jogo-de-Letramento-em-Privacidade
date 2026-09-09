extends AnimatedSprite2D


func _ready():
	Global.fase_atual = 1
	Global.resetar_vidas()
	play("default")
	

func _on_animation_finished() -> void:
	get_tree().change_scene_to_file("res://cena1_2.tscn")
