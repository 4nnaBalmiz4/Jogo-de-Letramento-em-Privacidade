extends Node2D

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var color_rect: ColorRect = $ColorRect

var trocando_cena: bool = false

func _ready() -> void:
	if color_rect:
		color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		color_rect.color = Color(0, 0, 0, 1.0)
		
		# Fade In inicial suave
		var tween_in = create_tween()
		tween_in.tween_property(color_rect, "color:a", 0.0, 0.6)
	
	if anim_sprite:
		anim_sprite.play("default")

func _on_animated_sprite_2d_frame_changed() -> void:
	if audio_player and audio_player.stream:
		audio_player.play()

func _on_animated_sprite_2d_animation_finished() -> void:
	_transicionar_para_cena2()

func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and event.pressed) or (event is InputEventKey and event.pressed):
		_transicionar_para_cena2()

func _transicionar_para_cena2() -> void:
	if trocando_cena:
		return
	trocando_cena = true
	
	if color_rect:
		# Fade Out suave para a cena 2
		var tween_out = create_tween()
		tween_out.tween_property(color_rect, "color:a", 1.0, 0.8)
		await tween_out.finished
	
	get_tree().change_scene_to_file("res://f3_cena2.tscn")
