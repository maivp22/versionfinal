extends AnimatedSprite2D
func _ready():
	$AnimatedSprite2D.play("1")

func _process(_delta):
	var intensidad = randf_range(1.2, 1.5)
	$PointLight2D.energy = intensidad
