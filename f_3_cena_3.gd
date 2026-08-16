extends Node2D

@onready var color_rect: ColorRect = $ColorRect

var trocando_cena: bool = false

func _ready() -> void:
	if color_rect:
		color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		color_rect.color = Color(0, 0, 0, 1.0)
		
		# Efeito Fade In (suave aparição da imagem)
		var tween_in = create_tween()
		tween_in.tween_property(color_rect, "color:a", 0.0, 0.8)
		await tween_in.finished
	
	# Fica visível por um tempinho (2.5 segundos)
	await get_tree().create_timer(2.5).timeout
	
	_transicionar_para_cena4()

func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and event.pressed) or (event is InputEventKey and event.pressed):
		_transicionar_para_cena4()

func _transicionar_para_cena4() -> void:
	if trocando_cena:
		return
	trocando_cena = true
	
	if color_rect:
		# Efeito Fade Out (transição suave para a cena 4)
		var tween_out = create_tween()
		tween_out.tween_property(color_rect, "color:a", 1.0, 0.8)
		await tween_out.finished
	
	get_tree().change_scene_to_file("res://f3_cena4.tscn")
