extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.fase_atual = 4


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_button_pressed() -> void:
	Global.fase_atual = 4
	get_tree().change_scene_to_file("res://gameOver.tscn")
