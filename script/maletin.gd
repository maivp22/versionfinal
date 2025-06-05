extends Area2D


func _ready():
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)

var player_cercano = null

func _on_body_entered(body):
	if body.is_in_group("Player"):
		player_cercano = body

func _on_body_exited(body):
	if body == player_cercano:
		player_cercano = null

func activar_skin_de_ataque():
	if player_cercano != null:
		player_cercano.cambiar_a_skin_ataque()
		queue_free()  # Se destruye el maletín tras activarse
