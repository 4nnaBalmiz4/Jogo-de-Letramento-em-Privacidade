extends Node2D

@onready var color_rect: ColorRect = $ColorRect
@onready var button: Button = $Button

var trocando_cena: bool = false

func _ready() -> void:
	if color_rect:
		color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		color_rect.color = Color(0, 0, 0, 1.0)
		var tween_in = create_tween()
		tween_in.tween_property(color_rect, "color:a", 0.0, 0.6)

func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and event.pressed) or (event is InputEventKey and event.pressed):
		_on_button_pressed()

func _on_button_pressed() -> void:
	if trocando_cena:
		return
	trocando_cena = true
	
	if color_rect:
		color_rect.mouse_filter = Control.MOUSE_FILTER_STOP
		var tween_out = create_tween()
		tween_out.tween_property(color_rect, "color:a", 1.0, 0.5)
		await tween_out.finished
	
	get_tree().change_scene_to_file("res://f3_cena3.tscn")
