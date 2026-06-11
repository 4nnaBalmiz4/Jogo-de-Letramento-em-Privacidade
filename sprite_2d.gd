extends Sprite2D
@export var duracao: float = 0.05       # duração do efeito em segundos
@export var voltas: float = 2.0        # quantas voltas completas vai dar
func _ready():
	rotation_degrees = 0.0
	var graus_totais = 360.0 * voltas

	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", graus_totais, duracao)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
