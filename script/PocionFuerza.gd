extends Area2D

@export var fuerza_extra: float = 10.0
@export var duracion: float = 5.0

var jugador_en_rango = null

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

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
		jugador_en_rango.aumentar_fuerza(fuerza_extra, duracion)
		queue_free()
