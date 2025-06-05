extends Area2D

@export var cantidad_vida = 25
var jugador_cerca = null

func _ready():
	$Label.visible = false
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	$AnimatedSprite2D.play("pocion")

func _on_body_entered(body):
	if body.is_in_group("Player"):
		jugador_cerca = body
		$Label.text = "Presiona E para recoger"
		$Label.visible = true

func _on_body_exited(body):
	if body == jugador_cerca:
		jugador_cerca = null
		$Label.visible = false

func _process(delta):
	if jugador_cerca != null and Input.is_action_just_pressed("interact"):
		await recoger(jugador_cerca)

func recoger(jugador) -> void:
	jugador.recibir_vida(cantidad_vida)
	$Label.text = "Poción de salud consumida"
	$Label.visible = true
	await get_tree().create_timer(0.8).timeout
	queue_free()
