extends Area2D

@export var velocidad_extra: float = 150.0
@export var duracion: float = 5.0

var jugador_en_rango = null

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	$AnimatedSprite2D.play("velocidad")
func _on_body_entered(body):
	if body.is_in_group("Player"):
		jugador_en_rango = body
		body.item_cercano = self
func _on_body_exited(body):
	if body.is_in_group("Player"):
		jugador_en_rango = null
		if body.item_cercano == self:
			body.item_cercano = null
func recoger():
	if jugador_en_rango != null:
		jugador_en_rango.aumentar_velocidad(velocidad_extra, duracion)
		queue_free()
